# http://stackoverflow.com/questions/2529990/activerecord-date-format
#
# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * description [text] - TODO: document me
# * duration [integer] - TODO: document me
# * ended_at [datetime] - TODO: document me
# * ends_at [datetime] - TODO: document me
# * record [boolean] - TODO: document me
# * recording [string] - TODO: document me
# * starts_at [datetime] - TODO: document me
# * teaser [string] - TODO: document me
# * title [string]
# * updated_at [datetime] - last update time
# * venue_id [integer] - belongs to :venue
class Talk < ActiveRecord::Base

  acts_as_taggable

  attr_accessible :title, :teaser, :starts_at, :duration,
                  :description, :record, :image, :tag_list

  belongs_to :venue, :inverse_of => :talks

  validates :venue, :title, :starts_at, :ends_at, :tag_list, presence: true

  before_validation :set_ends_at

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
  # TODO maybe we should use a date base folder structure
  def recording_path
    base = Settings.rtmp.recordings_path
    path = "#{base}/#{id}"
  end

  def merge_audio!(strategy=nil)
    Audio::Merger.run(recording_path, strategy)
  end

  def transcode_audio!(strategy=nil, ext=nil)
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

end
