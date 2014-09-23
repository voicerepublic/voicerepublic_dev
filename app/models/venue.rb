# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * description [text] - TODO: document me
# * image_uid [string] - TODO: document me
# * options [text, default="--- {}\n"] - TODO: document me
# * slug [string] - TODO: document me
# * teaser [string] - TODO: document me
# * title [string]
# * updated_at [datetime, not null] - last update time
# * uri [string] - TODO: document me
# * user_id [integer] - belongs to :user
class Venue < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  STREAMER_CONFIG         = Settings.rtmp
  # RECORDINGS_PATH = "#{Rails.root}/public/system/recordings"
  RECORDINGS_PATH         = Settings.rtmp.recordings_path
  # RECORDINGS_ARCHIVE_PATH = "#{Rails.root}/public/system/recordings_raw_archive"
  RECORDINGS_ARCHIVE_PATH = Settings.rtmp.archive_path

  acts_as_taggable

  # TODO: rename to host
  belongs_to :user

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :talks, dependent: :destroy, inverse_of: :venue

  has_many :participations, dependent: :destroy
  # TODO: rename to participants
  has_many :users, through: :participations
  has_many :social_shares, as: :shareable, dependent: :destroy

  has_one :default_user, foreign_key: :default_venue_id,
          class_name: 'User', dependent: :nullify

  validates :title, :teaser, :description, :tag_list, presence: true

  validates :title, length: { maximum: Settings.limit.string }
  validates :teaser, length: { maximum: Settings.limit.string }
  validates :description, length: { maximum: Settings.limit.text }

  before_save :clean_taglist # prevent vollpfosten from adding hash-tag to tag-names

  accepts_nested_attributes_for :talks

  serialize :options

  scope :of_user,  proc { |user| where(user_id: user.id) } # TODO check if needed
  scope :featured, proc { where('featured_from <= ?', Time.now.in_time_zone).
                          order('featured_from DESC') }

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/venue-image.jpg')
  end

  include PgSearch
  multisearchable against: [:tag_list, :title, :teaser, :description]

  # provides easier access to options
  # and allows strings as keys in yaml
  def opts
    OpenStruct.new(options)
  end

  def description_as_plaintext
    Nokogiri::HTML(description).text
  end

  private

  def clean_taglist
    # FIXME: WTF? this doesn't do anything, check it out
    #   v
    self_tag_list = tag_list.map { |t| t.tr_s(' ', '_').gsub('#', '') }
  end

  def slug_candidates
    [ :title, [:id, :title] ]
  end

end
