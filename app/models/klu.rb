class Klu < ActiveRecord::Base
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :charge_type, :charge_amount, :tag_list
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  
  validates :title, :presence => true
  validates :user_id, :presence => true
  
  scope :published, where("published=?", true)
  
  
  def status_or_about
    if uses_status && ! user.status_updates.empty?
      ret = self.user.status_updates.order("created_at DESC").limit(1).first.content
    else
      ret = self.user.account.about
    end
    ret.nil? || ret.blank? ? "..." : ret
  end
  
end
