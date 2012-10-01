class Klu < ActiveRecord::Base
  
  has_many :video_sessions, :inverse_of => :klu
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :tag_list
  #because of sti here in superclass
  attr_accessible :charge_type, :charge_amount, :currency
  
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  
  validates_presence_of :title, :user_id

  scope :published, where("published=?", true)
  
  WEIGHTS = {
  :tag_name => 12,
  :title => 15,
  :description => 7,
  :category_name => 6
  }
  
  define_index do
    indexes title
    indexes taggings.tag.name, :as => :tag_name
    indexes description
    indexes category.name, :as => :category_name
    indexes [user.firstname, user.lastname], :as => :user_name
    indexes type, :as => :klu_type
    # attributes  - used for filtering / sorting
    has category_id, :type => :integer
    has user_id, :type => :integer
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
  
  def complementaries
    cat = self.category
    tags = self.tag_list
    klu_class = self.instance_of?(Kluuu) ? NoKluuu : Kluuu
    
    ret = klu_class.search(self.title, :with => { :category_id => cat.id}, 
                            :without => { :user_id => self.user_id } 
                           )
    
   #Article.search "pancakes", :field_weights => {
   #:title => 10,
   #:tags    => 6,
   #:content => 3
   #
   #rticle.search 'pancakes waffles', :star => true
   #rticle.search_count 'pancakes'
    
  end
  
end
