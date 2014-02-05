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
# * start_time [datetime] - TODO: document me
# * teaser [text] - TODO: document me
# * title [string]
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class Venue < ActiveRecord::Base

  STREAMER_CONFIG         = Settings.rtmp
  RECORDINGS_PATH         = "#{Rails.root}/public/system/recordings"
  RECORDINGS_ARCHIVE_PATH = "#{Rails.root}/public/system/recordings_raw_archive"

  acts_as_taggable

  attr_accessible :title, :teaser, :description, :tag_list,
                  :talks_attributes

  belongs_to :user

  has_many :articles, -> { order "created_at DESC" }, :dependent => :destroy
  has_many :talks, :dependent => :destroy, :inverse_of => :venue

  has_many :participations, :dependent => :destroy
  has_many :users, :through => :participations

  validates :title, :teaser, :description, :tag_list, :presence => true

  before_save :clean_taglist # prevent vollpfosten from adding hash-tag to tag-names

  accepts_nested_attributes_for :talks

  scope :of_user,           proc { |user| where(:user_id => user.id) }
  scope :featured,          proc { where('featured_from <= ?', Time.now.in_time_zone).
                                     order('featured_from DESC') }

  attr_accessible :image
  has_attached_file :image,
    :styles => { :medium => '242x145>', :thumb => "100x100>" },
    :default_url => "/images/:style/missing.png"

  define_index do
    indexes title, :as => :title, :sortable => true
    indexes taggings.tag.name, :as => :tags
    indexes talks.title, :as => :talks_title
  end

  # # this is rendered as json in venue/venue_show_live
  # def details_for(user)
  #   {
  #     streamId: "v#{id}-e#{current_event.id}-u#{user.id}",
  #     channel: story_channel,
  #     role: (self.user == user) ? 'host' : 'participant',
  #     storySubscription: PrivatePub.subscription(channel: story_channel),
  #     backSubscription: PrivatePub.subscription(channel: back_channel),
  #     chatSubscription: PrivatePub.subscription(channel: channel_name),
  #     streamer: (current_event.record ? STREAMER_CONFIG['recordings'] : STREAMER_CONFIG['discussions'])
  #   }
  # end

  # the event channel propagates events, which get replayed on join
  def story_channel
    "/story/v#{id}e#{current_event.id}"
  end

  # the back channel propagates events, which don't get replayed
  def back_channel
    "/back/v#{id}e#{current_event.id}"
  end

  def chat_name
    "vgc-#{id}-#{current_event.id}"
  end

  def channel_name
    "/chatchannel/vgc-#{self.id}e#{current_event.id}"
  end

  def channel_host_info
    "/chatchannel/host-info/vgc-#{self.id}"
  end

  private

  def clean_taglist
    self_tag_list = tag_list.map { |t| t.tr_s(' ', '_').gsub('#', '') }
  end

end
