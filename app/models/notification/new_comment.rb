class Notification::NewComment < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :url, :user, :other
 
  belongs_to :user
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :content, :url, :presence => true
  
  def to_s
    I18n.t('.you_got_a_new_comment_by', :commenter => other.name)
  end
  
end