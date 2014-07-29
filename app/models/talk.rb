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
# * collect [boolean, default=true] - TODO: document me
# * created_at [datetime] - creation time
# * description [text] - TODO: document me
# * duration [integer, default=30] - TODO: document me
# * ended_at [datetime] - TODO: document me
# * ends_at [datetime] - TODO: document me
# * featured_from [datetime] - TODO: document me
# * grade [string] - TODO: document me
# * image_uid [string] - TODO: document me
# * language [string, default="en"] - TODO: document me
# * play_count [integer, default=0] - TODO: document me
# * processed_at [datetime] - TODO: document me
# * recording_override [string] - TODO: document me
# * related_talk_id [integer] - TODO: document me
# * session [text] - TODO: document me
# * started_at [datetime] - TODO: document me
# * starts_at [datetime] - TODO: document me
# * starts_at_date [string] - local date
# * starts_at_time [string] - local time
# * state [string] - TODO: document me
# * storage [text, default="--- {}\n"] - TODO: document me
# * teaser [string] - TODO: document me
# * title [string]
# * updated_at [datetime] - last update time
# * uri [string] - TODO: document me
# * venue_id [integer] - belongs to :venue
class Talk < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  include ActiveModel::Transitions

  LANGUAGES = YAML.load(File.read(File.expand_path('config/languages.yml', Rails.root)))

  GRACE_PERIOD = 5.minutes

  # colors according to ci style guide
  COLORS = %w( #182847 #2c46b0 #54c6c6 #a339cd )

  # https://github.com/troessner/transitions
  state_machine auto_scopes: true do
    state :prelive # initial
    state :halflive
    state :live
    state :postlive
    state :processing
    state :archived
    event :start_talk, timestamp: :started_at, success: :after_start do
      # standard path (if `start_button` is not set)
      transitions from: :prelive, to: :live, guard: ->(t){ !t.venue.opts.start_button }
      # alternative path (if `start_button` is set)
      transitions from: :prelive, to: :halflive
      transitions from: :halflive, to: :live
    end
    event :end_talk, timestamp: :ended_at, success: :after_end do
      transitions from: :live, to: :postlive
    end
    event :process do
      transitions from: :postlive, to: :processing
    end
    event :archive, timestamp: :processed_at do
      transitions from: :processing, to: :archived
      # in rare case we might to override a talk
      # which has never been postprocessed
      transitions from: :postlive, to: :archived
      # or which has never even happended
      transitions from: :prelive, to: :archived
    end
  end

  acts_as_taggable

  belongs_to :venue, :inverse_of => :talks
  has_many :appearances, dependent: :destroy
  has_many :guests, through: :appearances, source: :user
  has_many :messages, dependent: :destroy
  has_many :social_shares, as: :shareable

  has_one :featured_talk, class_name: "Talk", foreign_key: :related_talk_id
  belongs_to :related_talk, class_name: "Talk", foreign_key: :related_talk_id

  validates :venue, :title, :tag_list, :duration, :description,
            :language, presence: true
  validates :starts_at_date, format: { with: /\A\d{4}-\d\d-\d\d\z/,
                                       message: I18n.t(:invalid_date) }
  validates :starts_at_time, format: { with: /\A\d\d:\d\d\z/,
                                       message: I18n.t(:invalid_time) }

  validates :title, length: { maximum: Settings.limit.string }
  validates :teaser, length: { maximum: Settings.limit.string }
  validates :description, length: { maximum: Settings.limit.text }

  before_save :set_starts_at
  before_save :set_ends_at
  after_create :notify_participants
  after_create :set_uri!, unless: :uri?

  # TODO: important, these will be triggered after each PUT, optimize
  after_save :set_guests
  after_save -> { flyer.generate! },
             if: ->(t) { t.starts_at_changed? || t.title_changed? }

  serialize :session
  serialize :storage

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

  include PgSearch
  multisearchable against: [:tag_list, :title, :teaser, :description]

  def description_as_plaintext
    Nokogiri::HTML(description).text
  end

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
    raise 'this method has been deprecated, plz fix your code'
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

  # generates an ephemeral path and returns the location for
  # redirecting to that path
  #
  # TODO check speed (it will make an API call to S3)
  def generate_ephemeral_path!(variant='.mp3')
    filename = "#{uri}/#{id}#{variant}"
    head = media_storage.files.new(key: filename)
    head.url(7.days.from_now)
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

  def flyer
    @flyer ||= Flyer.new(self)
  end

  # this is only for user acceptance testing!
  def make_it_start_soon!(delta=1.minute)
    self.reload
    self.starts_at_date = Time.now.strftime('%Y-%m-%d')
    self.starts_at_time = delta.from_now.strftime('%H:%M')
    self.state = :prelive
    self.save!
    PrivatePub.publish_to public_channel, event: 'Reload'
    self
  end

  # this is only for user acceptance testing!
  def reset_to_postlive!
    raise 'reset_to_postlive! has to be fixed to work with s3'
    self.reload
    archive_raw = File.expand_path(Settings.rtmp.archive_raw_path, Rails.root)
    base = File.dirname(File.join(archive_raw, recording.to_s))
    target = Settings.rtmp.recordings_path
    FileUtils.mv(Dir.glob("#{base}/t#{id}-u*.flv"), target)
    self.recording = nil
    self.state = :postlive
    self.save!
    self.reload
    self
  end

  # returns the next talk (coming up next) talk in the series
  def next_talk
    begin
      talks = venue.talks.order(:starts_at)
      talk_index = talks.find_index(self)
      return talks[talk_index+1]
    rescue
      nil
    end
  end

  def effective_duration # in seconds
    ended_at - started_at
  end

  def podcast_file
    storage["#{uri}/#{id}.mp3"]
  end


  private

  # upload file to storage
  def upload_file(key, file)
    return unless key and file
    handle = File.open(file)
    ext = key.split('.').last
    # Explicity set content type via Mime::Type, otherwise
    # Fog will use MIME::Types to determine the content type
    # and MIME::Types is a horrible, horrible beast.
    ctype = Mime::Type.lookup_by_extension(ext)
    media_storage.files.create key: key, body: handle, content_type: ctype
  end

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
    Delayed::Job.enqueue(EndTalk.new(id: id), queue: 'trigger', run_at: delta)
  end

  def after_end
    PrivatePub.publish_to public_channel, { event: 'EndTalk', origin: 'server' }
    unless venue.opts.no_auto_postprocessing
      Delayed::Job.enqueue(Postprocess.new(id: id), queue: 'audio')
    end
    PrivatePub.publish_to '/monitoring', { event: 'EndTalk', talk: attributes }
  end

  def postprocess!(uat=false)
    raise 'fail: postprocessing a talk with override' if recording_override?
    # TODO: move into a final state != archived (over/past/gone/myth)
    return unless collect?
    return if archived? # silently guard against double processing

    logfile.puts "\n\n# --- postprocess (#{Time.now}) ---"

    process!
    chain = venue.opts.process_chain
    chain ||= Setting.get('audio.process_chain')
    chain = chain.split(/\s+/)
    run_chain! chain, uat
    archive!
  end

  def reprocess!(uat=false)
    raise 'fail: reprocessing a talk without recording' unless collect?
    raise 'fail: reprocessing a talk with override' if recording_override?

    logfile.puts "\n\n# --- reprocess (#{Time.now}) ---"

    # move files back into position for processing
    target = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
    # TODO optimize only pick the files referenced in `storage`
    media_storage.files.each do |file|
      next unless file.key =~ /^#{uri}\//
      next unless file.key =~ /\.(flv|journal)$/
      path = File.join(target, File.basename(file.key))
      logfile.puts "#R# s3cmd get s3://#{media_storage.key}/#{file.key} #{path}"
      File.open(path, 'wb') { |f| f.write(file.body) }
    end

    chain = venue.opts.process_chain
    chain ||= Setting.get('audio.process_chain')
    chain = chain.split(/\s+/)
    run_chain! chain, uat
  end

  # FIXME cleanup the wget/cp spec mess with
  # http://stackoverflow.com/questions/2263540
  def process_override!(uat=false)
    raise 'recording_override not set' if recording_override.blank?
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
        # fetch files from s3
        if url =~ /^s3:\/\//
          cmd = "#R# s3cmd get #{url} #{tmp} # (ruby code)"
          key = url.sub("s3://#{media_storage.key}/", '')
          file = media_storage.files.get(key)
          File.open(tmp, 'wb') { |f| f.write(file.body) }
        end
        logfile.puts cmd
        %x[ #{cmd} ]
        # guard against 0-byte overrides
        raise 'Abort process override, override has 0 bytes.' if File.size(tmp) == 0
        # convert to ogg
        ogg = "override-#{id}.ogg"
        cmd = "avconv -v quiet -i #{tmp} #{tmp}.wav; oggenc -Q -o #{ogg} #{tmp}.wav"
        logfile.puts cmd
        %x[ #{cmd} ]
        # upload ogg to s3
        key = uri + "/" + ogg
        logfile.puts "#R# s3cmd put #{ogg} to s3://media_storage.key/#{key}"
        upload_file(key, file)
        # store reference
        path = "s3://#{media_storage.key}/#{key}"
        update_attribute :recording_override, path
        cache_storage_metadata(ogg) and save!
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

    archive! unless archived?
  end

  def run_chain!(chain, uat=false)
    PrivatePub.publish_to public_channel, { event: 'Process' }
    PrivatePub.publish_to '/monitoring', { event: 'Process', talk: attributes }
    t0 = Time.now.to_i

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

    # delete some files (mainly wave files, we'll keep only flv
    # and compressed files)
    logfile.puts '# delete wav files'
    FileUtils.rm(Dir.glob("#{base}/t#{id}-u*.wav"), verbose: true)
    FileUtils.rm(Dir.glob("#{base}/#{id}-*.wav"), verbose: true)
    FileUtils.rm(Dir.glob("#{base}/#{id}.wav"), verbose: true)

    # move everything to fog storage
    files = ( Dir.glob("#{base}/t#{id}-u*.flv") +
              Dir.glob("#{base}/#{id}.journal") +
              Dir.glob("#{base}/#{id}.*") +
              Dir.glob("#{base}/#{id}-*.*") ).uniq
    files.each do |file|
      cache_storage_metadata(file)
      key = "#{uri}/#{File.basename(file)}"
      logfile.puts "#R# s3cmd put #{file} s3://#{media_storage.key}/#{key}"
      upload_file(key, file)
      FileUtils.rm(file, verbose: true)
    end

    FileUtils.fileutils_output = $stderr
    # TODO: save transcoded audio formats

    save! # save `storage` field

    dt = Time.now.to_i - t0
    logfile.puts "## Elapsed time: %s:%02d:%02d" % [dt / 3600, dt % 3600 / 60, dt % 60]
    PrivatePub.publish_to public_channel, { event: 'Archive', links: media_links }
    PrivatePub.publish_to '/monitoring', { event: 'Archive', talk: attributes }
  end

  # collect information about what's stored via fog
  def cache_storage_metadata(file=nil)
    return all_files.map { |file| cache_storage_metadata(file) } if file.nil?

    key = "#{uri}/#{File.basename(file)}"
    self.storage ||= {}
    self.storage[key] = {
      key:      key,
      ext:      File.extname(file),
      size:     File.size(file),
      duration: Avconv.duration(file),
      start:    Avconv.start(file)
    }
    # add duration in seconds
    if dur = storage[key][:duration]
      h, m, s = dur.split(':').map(&:to_i)
      self.storage[key][:seconds] = (h * 60 + m) * 60 + s
    end
    storage
  end

  def media_storage
    @media_storage ||=
      Storage.directories.new(key: Settings.storage.media, prefix: uri)
  end

  def logfile
    return @logfile unless @logfile.nil?
    path = File.expand_path(Settings.paths.log, Rails.root)
    FileUtils.mkdir_p(path)
    @logfile = File.open(File.join(path, "#{id}.log"), 'a')
    @logfile.sync = true
    @logfile
  end

  def set_uri!
    self.uri = "vr-#{id}"
    save!
  end

  # generically propagate all state changes to faye
  #
  # TODO cleanup publish statements scattered all over the code above
  def event_fired(*args)
    PrivatePub.publish_to '/event/talk', { talk: attributes, args: args }
  end

  def slug_candidates
    [ :title, [:id, :title] ]
  end

end
