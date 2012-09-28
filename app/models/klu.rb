class Klu < ActiveRecord::Base
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :charge_type, :charge_amount, :tag_list
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  
  validates :title, :presence => true
  validates :user_id, :presence => true
  
  scope :published, where("published=?", true)
  
  WEIGHTS = {
  :tag_name => 12,
  :title => 10,
  :description => 7,
  :category_name => 6
  }
  
  define_index do
    indexes title
    indexes taggings.tag.name, :as => :tag_name
    indexes description
    indexes category.name, :as => :category_name
    indexes [user.firstname, user.lastname], :as => :user_name
    has type
    has category_id
    has charge_type
    has charge_amount, :type => :integer
    has updated_at
    has created_at
    where "published = true"
  end
  
  
  
  def status_or_about
    if uses_status && ! user.status_updates.empty?
      ret = self.user.status_updates.order("created_at DESC").limit(1).first.content
    else
      ret = self.user.account.about
    end
    ret.nil? || ret.blank? ? "..." : ret
  end
  
end
