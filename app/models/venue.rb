# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * description [text] - TODO: document me
# * duration [integer] - TODO: document me
# * featured_from [datetime] - TODO: document me
# * image_content_type [string] - Paperclip for image
# * image_file_name [string] - Paperclip for image
# * image_file_size [integer] - Paperclip for image
# * image_updated_at [datetime] - Paperclip for image
# * options [text, default="--- {}\n"] - TODO: document me
# * start_time [datetime] - TODO: document me
# * teaser [text] - TODO: document me
# * title [string]
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class Venue < ActiveRecord::Base

  STREAMER_CONFIG         = Settings.rtmp
  # RECORDINGS_PATH = "#{Rails.root}/public/system/recordings"
  RECORDINGS_PATH         = Settings.rtmp.recordings_path
  # RECORDINGS_ARCHIVE_PATH = "#{Rails.root}/public/system/recordings_raw_archive"
  RECORDINGS_ARCHIVE_PATH = Settings.rtmp.archive_path

  acts_as_taggable

  attr_accessible :title, :teaser, :description, :tag_list,
                  :talks_attributes

  # TODO: rename to host
  belongs_to :user

  has_many :articles, -> { order "created_at DESC" }, :dependent => :destroy
  has_many :talks, :dependent => :destroy, :inverse_of => :venue

  has_many :participations, :dependent => :destroy
  # TODO: rename to participants
  has_many :users, :through => :participations
  has_many :social_shares, as: :shareable

  validates :title, :teaser, :description, :tag_list, :presence => true

  before_save :clean_taglist # prevent vollpfosten from adding hash-tag to tag-names

  accepts_nested_attributes_for :talks

  serialize :options

  scope :of_user,  proc { |user| where(:user_id => user.id) }
  scope :featured, proc { where('featured_from <= ?', Time.now.in_time_zone).
                          order('featured_from DESC') }

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/venue-image.jpg')
  end
  
  include PgSearch
  multisearchable against: [:tag_list, :title, :teaser, :description]

  private

  def clean_taglist
    # FIXME: WTF? this doesn't do anything, check it out
    #   v
    self_tag_list = tag_list.map { |t| t.tr_s(' ', '_').gsub('#', '') }
  end

end
