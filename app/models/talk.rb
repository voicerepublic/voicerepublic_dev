# Talk uses a strategy chain to process the audio.
#
# Example Strategy Chain
#
#    %w( precursor kluuu_merge trim auphonic )
#
# See the strategies in lib/audio/strategy for more details.
#
#
# http://stackoverflow.com/questions/2529990/activerecord-date-format
#
#
# Attributes:
# * id [integer, primary, not null] - primary key
# * audio_formats [text, default="--- []\n"] - TODO: document me
# * created_at [datetime] - creation time
# * description [text] - TODO: document me
# * duration [integer] - TODO: document me
# * ended_at [datetime] - TODO: document me
# * ends_at [datetime] - TODO: document me
# * featured_from [datetime] - TODO: document me
# * image_uid [string] - TODO: document me
# * record [boolean] - TODO: document me
# * recording [string] - TODO: document me
# * session [text] - TODO: document me
# * started_at [datetime] - TODO: document me
# * starts_at [datetime] - TODO: document me
# * state [string] - TODO: document me
# * teaser [string] - TODO: document me
# * title [string]
# * updated_at [datetime] - last update time
# * venue_id [integer] - belongs to :venue
class Talk < ActiveRecord::Base

  include ActiveModel::Transitions

  GRACE_PERIOD = 5.minutes

  ARCHIVE_STRUCTURE = "%Y/%m/%d"

  state_machine do
    state :prelive # initial
    state :live
    state :postlive
    state :processing
    state :archived
    event :start_talk, timestamp: :started_at, success: :after_start do
      transitions from: :prelive, to: :live
    end
    event :end_talk, timestamp: :ended_at, success: :after_end do
      transitions from: :live, to: :postlive
    end
    event :process do
      transitions from: :postlive, to: :processing
    end
    event :archive, timestamp: :processed_at do
      transitions from: :processing, to: :archived
    end
  end

  acts_as_taggable

  attr_accessible :title, :teaser, :starts_at, :duration,
                  :description, :record, :image, :tag_list,
                  :guest_list

  belongs_to :venue, :inverse_of => :talks
  has_many :appearances, dependent: :destroy
  has_many :guests, through: :appearances, source: :user
  has_many :messages, dependent: :destroy
  has_many :social_shares, as: :shareable

  validates :venue, :title, :starts_at, :ends_at, :tag_list, presence: true

  before_validation :set_ends_at
  after_create :notify_participants
  after_save :set_guests

  serialize :session

  serialize :audio_formats, Array

  delegate :user, to: :venue

  dragonfly_accessor :image

  # TODO remove and use scopes based on statemachine instead
  scope :upcoming, -> { where("ends_at > DATE(?)", Time.now) }
  scope :archived, -> { where("ends_at < DATE(?)", Time.now) }

  scope :featured, -> do
    where("featured_from < DATE(?)", Time.now).
      order('featured_from DESC')
  end

  scope :audio_format, ->(format) do # TODO: check if needed
    where('audio_formats LIKE ?', "%#{format}%")
  end

  scope :without_audio_format, ->(format) do # TODO: check if needed
    where('audio_formats NOT LIKE ?', "%#{format}%")
  end

  include PgSearch
  multisearchable against: [:tag_list, :title, :teaser, :description]
  
  def guest_list
    guests.pluck(:lastname).sort * ','
  end

  def guest_list=(list)
    @guest_list = list.split(',').sort
  end

  def starts_in # seconds (for prelive) # TODO: check if needed
    (starts_at - Time.now).to_i
  end

  def ends_in # seconds (for live) # TODO: check if needed
    (ends_at - Time.now).to_i
  end

  def config_for(user)
    LivepageConfig.new(self, user).to_json
  end

  def public_channel
    "/t#{id}/public"
  end

  def download_links
    return {} unless recording
    archive = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    glob = "#{archive}/#{recording}.*"
    files = Dir.glob(glob)
    formats = files.map { |f| f.split('.').last } - [ 'wav' ]
    formats.inject({}) { |r, f| r.merge f => generate_ephemeral_path!(".#{f}") }
  end

  # generates an ephemeral path (which is realized as a symlink) and
  # returns the location for redirecting to that path
  #
  # symlink pattern
  #
  #   public/audio/:year/:month/:day/:token-:id:variant
  #
  # target pattern (links to)
  #
  #   :archive/:recording:variant
  #
  # the interpolations are
  #
  #  * year, month, day - of now
  #  * token - a long (48 byte) urlsafe random token
  #  * id - the id of the talk
  #  * variant - something like '.wav' or '-pj.m4a'
  #  * archive - the base directory for the archive
  #  * recording - the physical location stored in column `recording`
  #
  # if the interpolation `variant` is not given as a parameter, it
  # defaults to '.wav'
  #
  def generate_ephemeral_path!(variant='.wav')
    # determine source
    base = Settings.rtmp.archive_path
    path = recording + variant
    source = File.expand_path(path, base)
    raise "File not found: #{source}" unless File.exist?(source)
    # determine & create target path
    token = SecureRandom.urlsafe_base64(48)
    loc_base = Rails.root.join 'public'
    loc_path = Time.now.strftime("system/audio/%Y/%m/%d")
    check = "#{loc_base}/#{loc_path}"
    FileUtils.mkdir_p(check) unless File.exist?(check)
    # determine and check availability of target file
    loc_file = "#{token}-#{id}#{variant}"
    target = "#{loc_base}/#{loc_path}/#{loc_file}"
    raise "File already exists: #{target}" if File.exist?(target)
    # create symlink
    FileUtils.ln_s(source, target)
    # return location url
    "/#{loc_path}/#{loc_file}"
  end

  private

  def set_ends_at
    return unless starts_at
    self.ends_at = starts_at + duration.minutes
  end

  def notify_participants
    return if venue.users.empty?
    venue.users.each do |participant|
      UserMailer.delay(queue: 'mail').new_talk(self, participant)
    end
  end

  def set_guests
    return if @guest_list.nil?
    return if @guest_list == guest_list.split(',')

    appearances.clear
    @guest_list.each do |lastname|
      if user_id = User.find_by(lastname: lastname).id
        appearances.create(user_id: user_id)
      end
    end
  end

  def after_start
    # this will fail silently if the talk has ended early
    delay(queue: 'trigger', run_at: ends_at + GRACE_PERIOD).end_talk!

    PrivatePub.publish_to '/monitoring', { event: 'StartTalk', talk: attributes }
  end

  def after_end
    PrivatePub.publish_to public_channel, { event: 'EndTalk', origin: 'server' }
    delay(queue: 'process_audio').postprocess!

    PrivatePub.publish_to '/monitoring', { event: 'EndTalk', talk: attributes }
  end

  def postprocess!
    return unless record? # TODO: move into a final state != archived
    process!
    PrivatePub.publish_to public_channel, { event: 'Process' }
    PrivatePub.publish_to '/monitoring', { event: 'Process', talk: attributes }

    # TODO: move into a column, stored as yaml
    chain = %w( precursor kluuu_merge trim m4a mp3 ogg
                move_clean jinglize m4a mp3 ogg )
    record = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
    setting = TalkSetting.new(record, id)
    # FIXME: sort to make sure
    file_start = setting.journal['record_done'].first.last.to_i
    setting.opts = {
      file_start: file_start,
      talk_start: talk.started_at.to_i,
      talk_stop:  talk.ended_at.to_i
    }
    runner = Audio::StrategyRunner.new(setting)
    chain.each_with_index do |name, index|
      attrs = { id: id, run: name, index: index, total: chain.size }
      PrivatePub.publish_to '/monitoring', { event: 'Postprocessing', talk: attrs }
      runner.run(name)
    end
    # save recording
    update_attribute :recording, Time.now.strftime(ARCHIVE_STRUCTURE) + "/#{id}"
    # move some files to archive_raw
    archive_raw = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    target = File.dirname(File.join(archive_raw, recording))
    FileUtils.mkdir_p(target)
    FileUtils.mv(Dir.glob("#{record}/t#{id}-u*.*"), target)
    FileUtils.mv(Dir.glob("#{record}/#{id}.journal"), target)
    # move some files to archive
    archive = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    target = File.dirname(File.join(archive, recording))
    FileUtils.mkdir_p(target)
    FileUtils.mv(Dir.glob("#{record}/#{id}.*"), target)
    FileUtils.mv(Dir.glob("#{record}/#{id}-*.*"), target)
    # TODO: save transcoded audio formats

    archive!
    PrivatePub.publish_to public_channel, { event: 'Archive', links: download_links }
    PrivatePub.publish_to '/monitoring', { event: 'Archive', talk: attributes }
  end

end
