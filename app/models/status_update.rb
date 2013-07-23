# Attributes:
# * id [integer, primary, not null] - primary key
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class StatusUpdate < ActiveRecord::Base
  #acts_as_commentable
  
  attr_accessible :content, :user_id
  belongs_to :user
  has_many :comments, :as => :commentable, :dependent => :destroy, :order => "created_at DESC"
  
  validates :user_id, :presence => true
  validates :content, :presence => true
  
  after_create :generate_notification
  
  private
  
  def generate_notification
    self.user.follower.each do |f|
      if f.account.prefs.inform_of_friends ==  "1"
        Notification::NewStatus.create(:user => f, :other => self.user, :content => self.content )
      end
    end
  end
  
end
