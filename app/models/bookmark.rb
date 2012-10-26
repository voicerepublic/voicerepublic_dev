class Bookmark < ActiveRecord::Base
  attr_accessible :description, :klu_id, :user_id, :klu
  
  belongs_to :user
  belongs_to :kluuu, :class_name => 'Kluuu', :foreign_key => :klu_id 
  belongs_to :no_kluuu, :class_name => 'NoKluuu',  :foreign_key => :klu_id 
  belongs_to :klu, :class_name => "Klu"
  
  validates :klu_id, :presence => true
  validates :user_id, :presence => true
  
  scope :with_kluuus, joins(:kluuu)
  scope :with_no_kluuus, joins(:no_kluuu)
  
  after_create :generate_notification
  
  def self.bookmarked?(user_id, klu_id)
    Bookmark.where("user_id=? AND klu_id=?", user_id, klu_id).empty? ? false : true
  end
  
  def self.bookmark_for(user_id, klu_id)
    Bookmark.where("user_id=? AND klu_id=?", user_id, klu_id).first
  end
  
  private
  
  def generate_notification
    _klu = self.kluuu || self.no_kluuu
    Notification::NewBookmark.create(:klu_id => _klu.id, :other => self.user, :user =>  _klu.user )
  end
  
end
