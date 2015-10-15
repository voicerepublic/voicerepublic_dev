# http://stackoverflow.com/questions/2529990/activerecord-date-format
#
# Attributes:
# * id [integer, primary, not null] - primary key
# * collect [boolean, default=true] - TODO: document me
# * created_at [datetime] - creation time
# * description [text] - TODO: document me
# * dryrun [boolean] - TODO: document me
# * duration [integer, default=30] - TODO: document me
# * edit_config [text] - TODO: document me
# * ended_at [datetime] - TODO: document me
# * ends_at [datetime] - TODO: document me
# * featured_from [datetime] - TODO: document me
# * grade [string] - TODO: document me
# * image_uid [string] - TODO: document me
# * language [string, default="en"] - TODO: document me
# * penalty [float, default=1.0] - TODO: document me
# * play_count [integer, default=0] - TODO: document me
# * popularity [float, default=1.0] - TODO: document me
# * processed_at [datetime] - TODO: document me
# * recording_override [string] - TODO: document me
# * related_talk_id [integer] - TODO: document me
# * session [text] - TODO: document me
# * slides_uuid [string] - TODO: document me
# * slug [string] - TODO: document me
# * speakers [string] - TODO: document me
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
# * user_override_uuid [string] - TODO: document me
# * series_id [integer] - belongs to :series
class Talk < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  include ActiveModel::Transitions

  LANGUAGES = YAML.load(File.read(File.expand_path('config/languages.yml', Rails.root)))

  # colors according to ci style guide
  COLORS = %w( #182847 #2c46b0 #54c6c6 #a339cd )

  # https://github.com/troessner/transitions
  state_machine auto_scopes: true do
    state :created # initial
    state :pending
    state :prelive
    state :live
    state :postlive
    state :processing
    state :archived
    event :prepare do
      # if user_override_uuid is set we transcend to pending
      transitions from: :created, to: :pending, guard: :user_override_uuid?
      # otherwise it will go its usual way via prelive
      transitions from: :created, to: :prelive
    end
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
      # or by user upload
      transitions from: :pending, to: :archived
      # in rare case we might to override a talk
      # which has never been postprocessed
      transitions from: :postlive, to: :archived
      # or which was supposed to but has never even happended
      transitions from: :prelive, to: :archived
    end
  end

  acts_as_taggable

  belongs_to :series, inverse_of: :talks
  belongs_to :venue
  has_many :appearances, dependent: :destroy
  has_many :guests, through: :appearances, source: :user
  has_many :messages, dependent: :destroy
  has_many :social_shares, as: :shareable
  has_many :reminders, as: :rememberable, dependent: :destroy

  has_one :featured_talk, class_name: "Talk", foreign_key: :related_talk_id
  belongs_to :related_talk, class_name: "Talk", foreign_key: :related_talk_id

  validates :title, :tag_list, :duration, :description,
            :language, :series, presence: true
  validates :starts_at_date, format: { with: /\A\d{4}-\d\d-\d\d\z/,
                                       message: I18n.t(:invalid_date) }
  validates :starts_at_time, format: { with: /\A\d\d:\d\d\z/,
                                       message: I18n.t(:invalid_time) }

  validates :title, length: { maximum: Settings.limit.string }
  validates :teaser, length: { maximum: Settings.limit.string }
  validates :description, length: { maximum: Settings.limit.text }

  validates :new_series_title, presence: true, if: ->(t) { t.series_id.nil? }

  # for temp usage during creation, we need this to hand the user
  # trough to associate with a default_series or create a new one
  attr_accessor :series_user
  attr_accessor :new_series_title

  before_validation :create_and_set_series, if: :create_and_set_series?
  before_save :set_starts_at
  before_save :set_ends_at
  before_save :set_popularity, if: :archived?
  before_save :set_description_as_html, if: :description_changed?
  before_create :prepare, if: :can_prepare?
  before_create :inherit_penalty
  after_create :notify_participants
  after_create :set_uri!, unless: :uri?
  after_create :create_and_process_debit_transaction!, unless: :dryrun?
  after_create :set_auto_destruct_mode, if: :dryrun?
  # TODO: important, these will be triggered after each PUT, optimize
  after_save :set_guests
  after_save :generate_flyer!, if: :generate_flyer?

  # Begin 'user audio upload'
  after_save -> { delay(queue: 'audio').user_override! },
             if: ->(t) { t.user_override_uuid_changed? and
                           !t.user_override_uuid.to_s.empty? }

  after_save :process_slides!, if: :process_slides?

  validates_each :starts_at_date, :starts_at_time do |record, attr, value|
    # guard against submissions where no upload occured or no starts_at
    # attributes have been given
    unless record.user_override_uuid.to_s.empty? or
      record.starts_at_time.to_s.empty? or
      record.starts_at_date.to_s.empty?
      if Time.zone.parse([record.starts_at_date, record.starts_at_time] * ' ') > DateTime.now
        record.errors.add attr, 'needs to be in the past'
      end
    end
  end
  # End 'user audio upload'

  serialize :listeners
  serialize :session
  serialize :storage
  serialize :social_links

  delegate :user, to: :series

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/talk-image.jpg')
  end

  scope :nodryrun, -> { where(dryrun: false) }

  scope :publicly_live, -> { nodryrun.live }
  scope :publicly_prelive, -> { nodryrun.prelive }

  scope :featured, -> do
    nodryrun.prelive.
      where("featured_from < ?", Time.zone.now).
      order('featured_from DESC')
  end

  scope :popular, -> { nodryrun.archived.order('popularity DESC') }
  scope :ordered, -> { order('starts_at ASC') }
  scope :reordered, -> { order('starts_at DESC') }

  scope :recent, -> do
    nodryrun.archived.order('ended_at DESC').
      where('featured_from IS NOT NULL')
  end

  scope :remembered_by, -> (user) do
    joins(:reminders).where('reminders.user_id = ?', user.id)
  end

  # only used for debugging, normally talks have at least one tag
  # (btw. this is the canonical and economical way to find untagged
  # entries)
  scope :untagged, -> { joins("LEFT JOIN taggings ON taggings.taggable_id " +
                              "= talks.id AND taggings.taggable_type = 'Talk'").
                        where("taggings.id IS NULL") }

  include PgSearch
  multisearchable against: [:tag_list, :title, :teaser, :description, :speakers]

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

  def public_channel
    "/t#{id}/public"
  end

  def media_links(variant='', formats=%w(mp3 m4a ogg))
    formats.inject({}) { |r, f| r.merge f => "/vrmedia/#{id}#{variant}.#{f}" }
  end

  def media_url(ext='mp3')
    Rails.application.routes.url_helpers.root_url + "/vrmedia/#{id}.#{ext}"
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

  # create a permanent url that redirects to a temp url via middleware
  def slides_url(perma=true)
    return nil if slides_uuid.blank?
    return nil if slides_uuid.match /^https?:\/\//
    if perma
      Rails.application.routes.url_helpers.root_url + "slides/#{id}"
    else
      # TODO make this a temporarily valid url
      "https://#{Settings.storage.upload_slides}.s3.amazonaws.com/#{slides_uuid}"
    end
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
    LiveServerMessage.call public_channel, event: 'Reload'
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
      talks = series.talks.order(:starts_at)
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

  def related_talks
    talks = series.talks.where.not(id: id).ordered.limit(9)
    if talks.empty?
      talks = Talk.joins(:series).
        where(series: { user_id: series.user_id }).
        where.not(id: id).ordered.limit(9)
    end
    if talks.empty?
      talks = Talk.popular.where.not(id: id).limit(9)
    end
    talks
  end

  def set_popularity
    raise "processed_at not set for talk #{id}" if processed_at.nil?

    age_in_hours = ( ( Time.now - processed_at ) / 3600 ).to_i

    rank = ( ( ( play_count - 1 ) ** 0.8 ).real / ( age_in_hours + 2 ) ** 1.8 ) * penalty

    self.popularity = rank
  end

  def set_penalty!(penalty)
    self.penalty = penalty
    set_popularity if archived?
    save!
  end

  # for use on console only
  def reinitiate_postprocess!
    self.update_attribute :state, :postlive
    self.postprocess!
  end

  def venue_name=(name)
    name = 'Default venue' if name.blank? # TODO centralize name
    self.venue = user.venues.find_or_create_by(name: name.strip)
  end

  # used for mobile app
  def image_url
    image.url
  end

  def self_url
    Rails.application.routes.url_helpers.talk_url(self)
  end

  def lined_up
    return nil unless venue.present?
    venue.talks.where('starts_at > ?', starts_at).ordered.first
  end

  private

  def set_description_as_html
    self.description_as_html = MD2HTML.render(description)
  end

  def create_and_set_series?
    series.nil? and new_series_title.present?
  end

  def create_and_set_series
    raise 'no series_user set while it should be' if series_user.nil?
    self.series = series_user.series.create title: new_series_title
  end

  # upload file to storage
  def upload_file(key, file)
    return unless key and file
    handle = File.open(file)
    ext = key.split('.').last
    # Explicity set content type via Mime::Type, otherwise
    # Fog will use MIME::Types to determine the content type
    # and MIME::Types is a horrible, horrible beast.
    ctype = Mime::Type.lookup_by_extension(ext)
    #puts "[DBG] Uploading %s to %s..." % [file, key]
    media_storage.files.create key: key, body: handle, content_type: ctype
    #puts "[DBG] Uploading %s to %s complete." % [file, key]
  rescue => e
    failcount ||= 0
    failcount += 1
    Rails.logger.error "On attempt #{failcount} upload of #{key} " +
                       "failed with '#{e.message}'"
    if failcount < 5
      Rails.logger.error "Retrying to upload #{key}."
      retry
    end
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
    return if series.users.empty?
    series.users.each do |participant|
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

  def set_auto_destruct_mode
    delta = created_at + 24.hours
    Delayed::Job.enqueue(DestroyTalk.new(id: id), queue: 'trigger', run_at: delta)
  end

  def after_start
    MonitoringMessage.call(event: 'StartTalk', talk: attributes)

    return unless venue.opts.autoend
    # this will fail silently if the talk has ended early
    delta = started_at + duration.minutes
    Delayed::Job.enqueue(EndTalk.new(id: id), queue: 'trigger', run_at: delta)
  end

  def after_end
    LiveServerMessage.call public_channel, { event: 'EndTalk', origin: 'server' }
    Delayed::Job.enqueue(Postprocess.new(id: id), queue: 'audio')
    MonitoringMessage.call(event: 'EndTalk', talk: attributes)
  end

  def postprocess!(uat=false)
    raise 'fail: postprocessing a talk with override' if recording_override?
    # TODO: move into a final state != archived (over/past/gone/myth)
    return unless collect?
    return if archived? # silently guard against double processing

    logfile.puts "\n\n# --- postprocess (#{Time.now}) ---"

    process!
    chain = series.opts.process_chain
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

    chain = series.opts.process_chain
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
    tmp_dir = FileUtils.mkdir_p("/tmp/recording_override/#{id}").first
    begin
      FileUtils.fileutils_output = logfile
      FileUtils.chdir(tmp_dir, verbose: true) do
        # download
        tmp = "t#{id}"
        url = recording_override
        # cp local files
        cmd = "cp #{url} #{tmp}"
        # use wget for real urls
        cmd = "wget --no-check-certificate " +
              "-q '#{url}' -O #{tmp}" if url =~ /^https?:\/\//
        # fetch files from s3
        if url =~ /^s3:\/\//
          puts "Downloading %s to %s..." % [url, tmp]
          cmd = "#R# s3cmd get #{url} #{tmp} # (ruby code)"
          key = url.sub("s3://#{media_storage.key}/", '')
          file = media_storage.files.get(key)
          File.open(tmp, 'wb') { |f| f.write(file.body) }
          puts "Downloading %s to %s complete." % [url, tmp]
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
        s3_path = "s3://#{media_storage.key}/#{key}"
        update_attribute :recording_override, s3_path
        cache_storage_metadata(ogg) and save!
        # move wav to `recordings`
        wav = tmp + '.wav'
        base = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
        target = File.join(base, "#{id}.wav")
        FileUtils.mv(wav, target, verbose: true)
      end
      FileUtils.fileutils_output = $stderr
    ensure
      FileUtils.remove_entry tmp_dir
    end

    chain = series.opts.override_chain
    chain ||= Setting.get('audio.override_chain')
    chain = chain.split(/\s+/)
    run_chain! chain, uat

    archive! unless archived?
  end

  # not obvious: the worker will call `upload_results!`
  # from its `after_chain` callback and `upload_flvs!`
  # from its `before_chain` callback.
  def run_chain!(chain, uat=false)
    path = update_manifest_file!(chain)
    Rails.logger.info "manifest: #{path}"
    worker = AudioProcessor.new(path) # see lib/audio_processor.rb
    worker.talk = self
    logfile = File.expand_path(File.join(Settings.rtmp.recordings_path,
                                         "process-#{id}.log"), Rails.root)

    ActiveSupport::Notifications.instrument "run_chain.audio_process.vr",
                                            chain: chain do
      worker.run(Logger.new(logfile))
    end
  end

  # move flvs to fog storage whil removing empty files
  def upload_flvs!
    base = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
    files = Dir.glob("#{base}/t#{id}-u*.flv")
    files.each do |file|
      # remove empty files
      next FileUtils.rm(file, verbose: true) if File.size?(file) == 0

      cache_storage_metadata(file)
      key = "#{uri}/#{File.basename(file)}"
      upload_file(key, file)
      # do not remove these files, we still need them for processing
    end

    save! # save `storage` field
  end

  # move results to fog storage
  def upload_results!
    base = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
    files = ( Dir.glob("#{base}/process-#{id}.log") +
              Dir.glob("#{base}/#{id}.journal") +
              Dir.glob("#{base}/#{id}.*") +
              Dir.glob("#{base}/#{id}-*.*") ).uniq
    files.each do |file|
      cache_storage_metadata(file)
      key = "#{uri}/#{File.basename(file)}"
      upload_file(key, file)
      FileUtils.rm(file, verbose: true)
    end

    # also remove flvs, these have been uploaded before
    FileUtils.rm(Dir.glob("#{base}/t#{id}-u*.flv"))

    # also remove manifest
    FileUtils.rm("#{base}/manifest-#{id}.yml")

    save! # save `storage` field
  end

  def manifest(chain=nil)
    chain ||= series.opts.process_chain || Setting.get('audio.process_chain')
    data = {
      id:         id,
      chain:      chain,
      talk_start: started_at.to_i,
      talk_stop:  ended_at.to_i,
      jingle_in:  locate(series.opts.jingle_in  || Settings.paths.jingles.in),
      jingle_out: locate(series.opts.jingle_out || Settings.paths.jingles.out)
    }
    data[:cut_conf] = edit_config.last['cutConfig'] unless edit_config.blank?
    data
  end

  def update_manifest_file!(chain=nil)
    base = File.expand_path(Settings.rtmp.recordings_path, Rails.root)
    name = "manifest-#{id}.yml"
    path, key = "#{base}/#{name}", "#{uri}/#{name}"
    File.open(path, 'w') { |f| f.puts(manifest(chain).to_yaml) }
    upload_file(key, path)
    path
  end

  # collect information about what's stored via fog
  def cache_storage_metadata(file=nil)

    basename = File.basename(file)
    key = "#{uri}/#{basename}"
    self.storage ||= {}
    self.storage[key] = {
      key:      key,
      basename: basename,
      ext:      File.extname(file),
      size:     File.size(file),
      duration: duration = Avconv.duration(file),
      start:    starts = Avconv.start(file).to_i
    }
    # add duration in seconds
    if duration
      h, m, s = duration.split(':').map(&:to_i)
      self.storage[key][:seconds] = seconds = (h * 60 + m) * 60 + s
      self.storage[key][:ends] = starts + seconds
    end
    storage
  end

  def media_storage
    @media_storage ||=
      Storage.directories.new(key: Settings.storage.media, prefix: uri)
  end

  def slides_storage
    @slides_storage ||=
      Storage.directories.new(key: Settings.storage.upload_slides)
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

  # generically propagate all state changes
  def event_fired(*args)
    TalkEventMessage.call(self, *args)
  end

  def slug_candidates
    [ :title, [:id, :title] ]
  end

  # gets triggered when a user has uploaded an override file
  def user_override!
    logger.info "Talk.find(#{id}).user_override! (with uuid #{user_override_uuid})"

    # with the current policy there is not need to talk to aws
    url = 'https://s3.amazonaws.com/%s/%s' %
          [ Settings.storage.upload_audio, user_override_uuid ]

    logger.info "URL: #{url}"

    # TODO use a more secure variant with fog
    # uploads = Storage.directories.get(Settings.storage.audio_upload)
    # upload = uploads.files.get(user_override_uuid)
    # url = upload.public_url.to_s

    update_attribute :recording_override, url
    process_override!

    # TODO: Delete the object only when process_override! was successfull
  end

  def generate_flyer?
    starts_at_changed? or title_changed?
  end

  def generate_flyer!
    # NOTE: I'm glad you asked. Yes, this could be delayed with
    #
    #     Delayed::Job.enqueue GenerateFlyer.new(id: id), queue: 'audio'
    #
    # But it is purposely not, since it's only one flyer at a time and
    # we want to have it available as soon as the user accesses `talks#show`.
    #
    # The BackOffice on the other hand facilitates mass imports, which
    # can be processed faster when deferring generating the flyer.
    flyer.generate!
  end

  def inherit_penalty
    self.penalty = series.penalty
  end

  def create_and_process_debit_transaction!
    DebitTransaction.create(source: self).process!
  end

  # TODO refactor this into some place where it makes sense
  # returns either a url or an absolute fs path
  def locate(path_or_url)
    return path_or_url if path_or_url.match(/^https?:/)
    File.expand_path(path_or_url, Rails.root)
  end

  def process_slides!
    # if it is a url, pull it and push it to s3 bucket, replace field with name
    if slides_uuid =~ /^https?:\/\//
      tmp = Tempfile.new(["slides-#{id}", '.pdf'])
      cmd = "wget --no-check-certificate -q -O #{tmp.path} '#{slides_uuid}'"
      %x[ #{cmd} ]
      ctype = Mime::Type.lookup_by_extension('pdf')
      key = File.basename(tmp.path)
      #puts "[DBG] Uploading from %s as %s ..." % [slides_uuid, key]
      file = slides_storage.files.create key: key, body: tmp,
                                         content_type: ctype, acl: 'public-read'
      #puts "[DBG] Uploading from %s as %s complete." % [slides_uuid, key]
      update_attribute :slides_uuid, key
      tmp.unlink
    end
    # if its a uuid nothing is to do

    # TODO to convert detach a job, something like...
    # BUNNY.publish queue: 'process.slides', talk_id: id, slides: slides_uuid
  end

  def process_slides?
    slides_uuid_changed? and slides_uuid.present?
  end

end
