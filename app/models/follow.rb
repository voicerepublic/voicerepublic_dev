# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * followed_id [integer] - belongs to :followed
# * follower_id [integer] - belongs to :follower
# * updated_at [datetime, not null] - last update time
class Follow < ActiveRecord::Base
  attr_accessible :followed_id, :follower_id
  
  belongs_to :follower, :class_name => 'User'
  belongs_to :followed, :class_name => 'User'
  
  validates :follower, :presence => true
  validates :followed, :presence => true
  
  
  after_create :generate_notification
  
  
  private
  
  def generate_notification
    Notification::NewFollower.create(:user_id => followed.id, :other_id => follower.id)
  end
end
