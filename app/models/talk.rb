# http://stackoverflow.com/questions/2529990/activerecord-date-format
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

  validates :venue, :title, :starts_at, :ends_at, :tag_list, presence: true

  before_validation :set_ends_at
  after_save :set_guests

  serialize :session

  serialize :audio_formats, Array

  delegate :user, to: :venue

  dragonfly_accessor :image

  scope :upcoming, -> { where("ends_at > DATE(?)", Time.now) }
  scope :archived, -> { where("ends_at < DATE(?)", Time.now) }

  scope :audio_format, ->(format) do
    where('audio_formats LIKE ?', "%#{format}%")
  end

  scope :without_audio_format, ->(format) do
    where('audio_formats NOT LIKE ?', "%#{format}%")
  end

  def guest_list
    guests.pluck(:lastname).sort * ','
  end

  def guest_list=(list)
    @guest_list = list.split(',').sort
  end

  def starts_in # seconds (for prelive)
    (starts_at - Time.now).to_i
  end

  def ends_in # seconds (for live)
    (ends_at - Time.now).to_i
  end

  def config_for(user)
    LivepageConfig.new(self, user).to_json
  end

  def public_channel
    "/t#{id}/public"
  end

  # TODO write this to recording when starting talk
  # TODO then use the stored value
  # TODO maybe we should use a date based folder structure
  def recording_path
    base = Settings.rtmp.recordings_path
    path = "#{base}/#{id}"
  end

  def check_journal!
    JournalFaker.run(recording_path)
  end

  def merge_audio!(strategy=nil)
    Audio::Merger.run(recording_path, strategy)
  end

  def transcode_audio!(strategy=nil, extension=nil)
    strategy ||= 'Audio::TranscodeStrategy::M4a'
    strategy = strategy.constantize if strategy.is_a?(String)
    extension ||= strategy::EXTENSION
    result = Audio::Transcoder.run(recording_path, strategy)
    audio_formats |= [ extension ]
    save!
    result
  end

  private

  def set_ends_at
    return unless starts_at
    self.ends_at = starts_at + duration.minutes
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
    # this should silently fail if the talk has ended early
    delay(queue: 'trigger', run_at: ends_at + GRACE_PERIOD).end_talk!
  end

  def after_end
    PrivatePub.publish_to public_channel, { event: 'EndTalk', origin: 'server' }
    delay(queue: 'process_audio').postprocess! if record?
  end

  def postprocess!
    return unless record? 
    process! # transition
    check_journal!
    merge_audio!
    transcode_audio!
    archive! # transition
  end

end
