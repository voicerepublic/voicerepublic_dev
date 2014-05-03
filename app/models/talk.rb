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
# * audio_formats [text, default="--- []\n"] - \n"] - TODO: document me
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
# * starts_at_date [string] - local date
# * starts_at_time [string] - local time
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

  attr_accessible :title, :teaser, :duration, :uri,
                  :description, :record, :image, :tag_list,
                  :guest_list, :starts_at_date, :starts_at_time

  belongs_to :venue, :inverse_of => :talks
  has_many :appearances, dependent: :destroy
  has_many :guests, through: :appearances, source: :user
  has_many :messages, dependent: :destroy
  has_many :social_shares, as: :shareable

  validates :venue, :title, :tag_list, :duration, :description, presence: true
  validates :starts_at_date, format: { with: /\A\d{4}-\d\d-\d\d\z/,
                                       message: I18n.t(:invalid_date) }
  validates :starts_at_time, format: { with: /\A\d\d:\d\d\z/,
                                       message: I18n.t(:invalid_time) }

  before_save :set_starts_at
  before_save :set_ends_at
  after_create :notify_participants
  after_save :set_guests
  after_save :generate_flyer

  serialize :session

  serialize :audio_formats, Array

  delegate :user, to: :venue

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/talk-image.jpg')
  end

  scope :featured, -> do
    where("featured_from < ?", Time.zone.now).
      where(state: [:prelive, :live]).
      order('featured_from DESC')
  end

  scope :popular, -> { archived.order('play_count DESC') }
  scope :ordered, -> { order('starts_at ASC') }

  scope :recent, -> do
    archived.order('ended_at DESC').
      where('featured_from IS NOT NULL')
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

  def remaining_seconds
    return starts_in if prelive?
    return ends_in if live?
    0
  end

  def starts_in # remaining seconds in state prelive
    starts_at.to_i - Time.now.to_i
  end

  def ends_in # remaining seconds in state live
    tstart = started_at || starts_at
    tend = tstart.to_i + duration.minutes
    tend - Time.now.to_i
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

  def media_links(variant='', formats=%w(mp3 m4a ogg))
    formats.inject({}) { |r, f| r.merge f => "/vrmedia/#{id}#{variant}.#{f}" }
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

  # returns either the web path (default)
  #
  #     e.g. /system/flyer/42.png
  #
  # or, if `fs` is true, the absolute file system path
  #
  #     e.g. /home/app/app/shared/public/system/flyer/42.png
  #
  def flyer_path(fs=false)
    name = "#{id}.png" # TODO use friendly id
    return Settings.flyer.location + '/' + name unless fs

    path = File.expand_path(Settings.flyer.path, Rails.root)
    FileUtils.mkdir_p(path)
    File.join(path, name)
  end

  # this is only for user acceptance testing!
  def make_it_start_soon!(delta=1.minute)
    self.reload
    self.starts_at_time = delta.from_now.strftime('%H:%M')
    self.state = :prelive
    self.save!
    PrivatePub.publish_to public_channel, event: 'Reload'
    self
  end

  def reset_to_postlive!
    self.reload
    archive_raw = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    base = File.dirname(File.join(archive_raw, recording))
    target = Settings.rtmp.recordings_path
    FileUtils.mv(Dir.glob("#{base}/t#{id}-u*.flv"), target)
    self.recording = nil
    self.state = :postlive
    self.save!
    self.reload
    self
  end

  private

  # Assemble `starts_at` from `starts_at_date` and `starts_at_time`.
  #
  # Since the validity of `starts_at_date` and `starts_at_time` is ensured
  # with regexes we are allowed to be optimistic about parsing here.
  def set_starts_at
    self.starts_at = Time.zone.parse([starts_at_date, starts_at_time] * ' ')
  end

  def set_ends_at
    return unless starts_at && duration # TODO check if needed
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

  def after_start
    PrivatePub.publish_to '/monitoring', { event: 'StartTalk', talk: attributes }

    return if venue.opts.no_auto_end_talk
    # this will fail silently if the talk has ended early
    delta = started_at + duration.minutes + GRACE_PERIOD
    delay(queue: 'trigger', run_at: delta).end_talk!
  end

  def after_end
    PrivatePub.publish_to public_channel, { event: 'EndTalk', origin: 'server' }
    unless venue.opts.no_auto_postprocessing
      Delayed::Job.enqueue(Postprocess.new(id), queue: 'audio')
    end
    PrivatePub.publish_to '/monitoring', { event: 'EndTalk', talk: attributes }
  end

  def postprocess!(uat=false)
    raise 'fail: postprocessing a talk with override' if recording_override?
    # TODO: move into a final state != archived (over/past/gone/myth)
    return unless record?
    return if archived? # silently guard against double processing

    logfile.puts "\n\n# --- postprocess (#{Time.now}) ---"

    process!
    chain = venue.opts.process_chain
    chain ||= Setting.get('audio.process_chain')
    chain = chain.split(/\s+/)
    run_chain! chain, uat
    archive!
  end

  # TODO this will leave orphaned versions of previous processings on disk
  def reprocess!(uat=false)
    raise 'fail: reprocessing a talk without recording' unless record?
    raise 'fail: reprocessing a talk with override' if recording_override?

    logfile.puts "\n\n# --- reprocess (#{Time.now}) ---"

    # move files back into position for processing
    archive_raw = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    base = File.dirname(File.join(archive_raw, recording))
    target = Settings.rtmp.recordings_path
    FileUtils.fileutils_output = logfile
    FileUtils.mv(Dir.glob("#{base}/t#{id}-u*.*"), target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}.journal"), target, verbose: true)
    FileUtils.fileutils_output = $stderr

    chain = venue.opts.process_chain
    chain ||= Setting.get('audio.process_chain')
    chain = chain.split(/\s+/)
    run_chain! chain, uat
  end

  # TODO this will leave orphaned versions of previous processings on disk
  #
  # FIXME cleanup the wget/cp spec mess with
  # http://stackoverflow.com/questions/2263540
  def process_override!(uat=false)
    logfile.puts "\n\n# --- override (#{Time.now}) ---"

    # prepare override
    Dir.mktmpdir do |path|
      FileUtils.fileutils_output = logfile
      FileUtils.chdir(path, verbose: true) do
        # download
        tmp = "t#{id}"
        url = recording_override
        # cp local files
        cmd = "cp #{url} #{tmp}"
        # use wget for real urls
        cmd = "wget -q '#{url}' -O #{tmp}" if url =~ /^https?:\/\//
        logfile.puts cmd
        %x[ #{cmd} ]
        # convert to ogg
        cmd = "avconv -v quiet -i #{tmp} #{tmp}.wav; oggenc -Q #{tmp}.wav"
        logfile.puts cmd
        %x[ #{cmd} ]
        # move ogg to archive
        ogg = tmp + '.ogg'
        path = Time.now.strftime(ARCHIVE_STRUCTURE) + "/override-#{id}.ogg"
        base = File.expand_path(Settings.rtmp.archive_path, Rails.root)
        target = File.join(base, path)
        FileUtils.mkdir_p(File.dirname(target), verbose: true)
        FileUtils.mv(ogg, target, verbose: true)
        # store reference
        update_attribute :recording_override, path
        # move wav to `recordings`
        wav = tmp + '.wav'
        base = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
        target = File.join(base, "#{id}.wav")
        FileUtils.mv(wav, target, verbose: true)
      end
      FileUtils.fileutils_output = $stderr
    end # unlinks tmp dir

    chain = venue.opts.override_chain
    chain ||= Setting.get('audio.override_chain')
    chain = chain.split(/\s+/)
    run_chain! chain, uat
  end

  def run_chain!(chain, uat=false)
    PrivatePub.publish_to public_channel, { event: 'Process' }
    PrivatePub.publish_to '/monitoring', { event: 'Process', talk: attributes }

    base = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
    opts = {
      talk_start: started_at.to_i,
      talk_stop:  ended_at.to_i,
      logfile: logfile
    }
    setting = TalkSetting.new(base, id, opts)
    runner = Audio::StrategyRunner.new(setting)
    FileUtils.fileutils_output = logfile
    FileUtils.chdir(setting.path, verbose: true) do
      chain.each_with_index do |name, index|
        attrs = { id: id, run: name, index: index, total: chain.size }
        PrivatePub.publish_to '/monitoring', { event: 'Processing', talk: attrs }
        (logger.debug "Next strategy: \033[31m#{name}\033[0m"; debugger) if uat
        runner.run(name)
      end
    end
    # save recording
    update_attribute :recording, Time.now.strftime(ARCHIVE_STRUCTURE) + "/#{id}"
    logfile.puts "# set `recording` to '#{recording}'"
    # delete some files (mainly wave files, we'll keep only flv
    # and compressed files)
    logfile.puts '# delete wav files'
    FileUtils.rm(Dir.glob("#{base}/t#{id}-u*.wav"), verbose: true)
    FileUtils.rm(Dir.glob("#{base}/#{id}-*.wav"), verbose: true)
    FileUtils.rm(Dir.glob("#{base}/#{id}.wav"), verbose: true)
    # move some files to archive_raw (journal and flv files)
    archive_raw = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    target = File.dirname(File.join(archive_raw, recording))
    logfile.puts "# move files to #{target}"
    FileUtils.mkdir_p(target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/t#{id}-u*.flv"), target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}.journal"), target, verbose: true)
    # move some files to archive (all other files)
    archive = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    target = File.dirname(File.join(archive, recording))
    logfile.puts "# move files to #{target}"
    FileUtils.mkdir_p(target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}.*"), target, verbose: true)
    FileUtils.mv(Dir.glob("#{base}/#{id}-*.*"), target, verbose: true)
    FileUtils.fileutils_output = $stderr

    # TODO: save transcoded audio formats

    PrivatePub.publish_to public_channel, { event: 'Archive', links: media_links }
    PrivatePub.publish_to '/monitoring', { event: 'Archive', talk: attributes }
  end

  def logfile
    return @logfile unless @logfile.nil?
    base = File.expand_path(Settings.rtmp.archive_path, Rails.root)
    path = File.join(base, Time.now.strftime(ARCHIVE_STRUCTURE))
    FileUtils.mkdir_p(path)
    @logfile = File.open(File.join(path, "#{id}.log"), 'a')
    @logfile.sync = true
    @logfile
  end

  # Generates a svg flyer and converts it to png via Inkscape.
  #
  # This can be run in bulk to regenerate all flyers:
  #
  #     FileUtils.rm(Dir.glob('app/shared/public/system/flyer/*.png'))
  #     Talk.find_each { |t| t.send(:generate_flyer) }
  #
  def generate_flyer
    svg_data = render_anywhere 'talks/flyer.svg', talk: self
    svg_file = Tempfile.new('svg')
    svg_file.write svg_data
    svg_file.close
    %x[ inkscape -f #{svg_file.path} -e #{flyer_path(true)} ]
    svg_file.unlink
  end

  # TODO this should move into trickery
  def render_anywhere(partial, assigns = {})
    view = ActionView::Base.new(ActionController::Base.view_paths, assigns)
    view.extend ApplicationHelper
    view.render partial: partial
  end

end
