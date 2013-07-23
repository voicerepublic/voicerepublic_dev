# Attributes:
# * id [integer, primary, not null] - primary key
# * anon_id [string] - TODO: document me
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * klu_id [integer] - belongs to :klu
# * other_id [integer] - belongs to :other
# * read [boolean] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * url [string] - TODO: document me
# * user_id [integer] - belongs to :user
# * video_session_id [integer] - TODO: document me
class Notification::FollowerAction < Notification::Base 
  attr_accessible :other_id, :user_id, :content
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
  belongs_to :klu
   
  validates :other_id, :user_id, :presence => true
  
  #before_create :check_account_preferences
  
  def to_s
    I18n.t('model_notification_follower_action.friend_took_action', :friend => other.name )
  end
  
  private
  
  #def check_account_preferences
  #  if user.account.prefs.inform_of_friends
  #    
  #  end
  #end
  
end
