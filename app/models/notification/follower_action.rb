class Notification::FollowerAction < Notification::Base 
  attr_accessible :other_id, :user_id, :content
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
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