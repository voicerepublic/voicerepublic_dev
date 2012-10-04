class Notification::NewBookmark < Notification::Base 
  attr_accessible :other_id, :user_id, :content, :klu_id
 
  belongs_to :user
  belongs_to :klu
  belongs_to :other, :class_name => 'User'
   
  validates :other_id, :user_id, :klu_id, :presence => true
  
  def to_s
    I18n.locale('.your_klu_got_bookmarked', :klu_title => klu.title, :bookmarker => other.name )
  end
  
end