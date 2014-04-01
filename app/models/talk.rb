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
# * duration [integer, default=30] - TODO: document me
# * ended_at [datetime] - TODO: document me
# * ends_at [datetime] - TODO: document me
# * featured_from [datetime] - TODO: document me
# * image_uid [string] - TODO: document me
# * play_count [integer, default=0] - TODO: document me
# * processed_at [datetime] - TODO: document me
# * record [boolean, default=true] - TODO: document me
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

  state_machine auto_scopes: true do
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

  attr_accessible :title, :teaser, :duration,
                  :description, :record, :image, :tag_list,
                  :guest_list, :starts_at_date, :starts_at_time

  belongs_to :venue, :inverse_of => :talks
  has_many :appearances, dependent: :destroy
  has_many :guests, through: :appearances, source: :user
  has_many :messages, dependent: :destroy
  has_many :social_shares, as: :shareable

  validates :venue, :title, :starts_at, :ends_at, :tag_list, :duration, presence: true

  before_validation :set_ends_at
  after_create :notify_participants
  before_save :prepopulate_session
  after_save :set_guests

  serialize :session

  serialize :audio_formats, Array

  delegate :user, to: :venue

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/talk-image.jpg')
  end

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

  # returns an array of json objects
  def guest_list
    guests.map(&:for_select).to_json
  end

  # accepts a string with a comma separated list of ids
  def guest_list=(list)
    @guest_list = list.split(',').sort
  end

  def starts_in # seconds (for prelive) # TODO: check if needed
    (starts_at - Time.now).to_i
  end

  def ends_in # seconds (for live) # TODO: check if needed
    (ends_at - Time.now).to_i
  end

  def starts_at_time
    starts_at
  end

  def starts_at_date
    starts_at
  end

  def starts_at_time=(time)
    datetime = DateTime.parse(time)
    self.starts_at ||= DateTime.new
    attrs = { hour: datetime.hour, min: datetime.min }
    self.starts_at = starts_at.change(attrs)
  end

  def starts_at_date=(date)
    datetime = DateTime.parse(date)
    self.starts_at ||= DateTime.new
    attrs = { year: datetime.year, month: datetime.month, day: datetime.day }
    self.starts_at = starts_at.change(attrs)
  end

  def config_for(user)
    LivepageConfig.new(self, user).to_json
  end

  def public_channel
    "/t#{id}/public"
  end

  # DO NOT USE THIS, it will undermine tracking of playcounts
  # use `media_links` instead
  def download_links
    return {} unless recording
    archive = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    glob = "#{archive}/#{recording}.*"
    files = Dir.glob(glob)
    formats = files.map { |f| f.split('.').last } - [ 'wav' ]
    formats.inject({}) { |r, f| r.merge f => generate_ephemeral_path!(".#{f}") }
  end

  def media_links(formats=%w(mp3 m4a ogg))
    formats.inject({}) { |r, f| r.merge f => "/vrmedia/#{id}-clean.#{f}" }
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

  # the message history is available as text file to the host
  def message_history
    attrs = {
      title: title,
      started_at: started_at ? I18n.l(started_at, format: :short) : "",
      ended_at: ended_at ? I18n.l(ended_at, format: :short) : ""
    }
    I18n.t('talks.message_history', attrs) + "\n" +
      messages.order('created_at ASC').joins(:user).map(&:as_text).join("\n\n")
  end

  private

  def set_ends_at
    return unless starts_at && duration
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
    return if @guest_list == appearances.pluck(:user_id).sort

    appearances.clear
    @guest_list.each do |id|
      appearances.create(user_id: id)
    end
  end

  def prepopulate_session
    return if @guest_list.nil?
    return if @guest_list == appearances.pluck(:user_id).sort

    self.session = {}
    guests.each do |guest|
      self.session[guest.id] = guest.details_for(self)
    end
  end

  def after_start
    PrivatePub.publish_to '/monitoring', { event: 'StartTalk', talk: attributes }

    return if venue.opts.no_auto_end_talk
    # this will fail silently if the talk has ended early
    delay(queue: 'trigger', run_at: ends_at + GRACE_PERIOD).end_talk!
  end

  def after_end
    PrivatePub.publish_to public_channel, { event: 'EndTalk', origin: 'server' }
    PrivatePub.publish_to '/monitoring', { event: 'EndTalk', talk: attributes }

    return if venue.opts.no_auto_postprocessing
    delay(queue: 'audio').postprocess!
  end

  def postprocess!(uat=false)
    return unless record? # TODO: move into a final state != archived
    process!
    PrivatePub.publish_to public_channel, { event: 'Process' }
    PrivatePub.publish_to '/monitoring', { event: 'Process', talk: attributes }

    chain = Setting.get('audio.process_chain').split(/\s+/)
    base = Settings.rtmp.recordings_path
    opts = {
      talk_start: started_at.to_i,
      talk_stop:  ended_at.to_i
    }
    setting = TalkSetting.new(base, id, opts)
    runner = Audio::StrategyRunner.new(setting)
    chain.each_with_index do |name, index|
      attrs = { id: id, run: name, index: index, total: chain.size }
      PrivatePub.publish_to '/monitoring', { event: 'Postprocessing', talk: attrs }
      (logger.debug "Next strategy: \033[31m#{name}\033[0m"; debugger) if uat
      runner.run(name)
    end
    # save recording
    update_attribute :recording, Time.now.strftime(ARCHIVE_STRUCTURE) + "/#{id}"
    # move some files to archive_raw
    archive_raw = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    target = File.dirname(File.join(archive_raw, recording))
    FileUtils.mkdir_p(target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/t#{id}-u*.*"), target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}.journal"), target, verbose: true)
    # move some files to archive
    archive = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    target = File.dirname(File.join(archive, recording))
    FileUtils.mkdir_p(target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}.*"), target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}-*.*"), target, verbose: true)
    # TODO: save transcoded audio formats

    archive!
    PrivatePub.publish_to public_channel, { event: 'Archive', links: media_links }
    PrivatePub.publish_to '/monitoring', { event: 'Archive', talk: attributes }
  end

end
