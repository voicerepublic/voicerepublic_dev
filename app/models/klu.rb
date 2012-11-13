class Klu < ActiveRecord::Base
  
  attr_accessible :available_at_times, :category_id, :description, :published, :title, :type, :user_id, :tag_list, :uses_status
  attr_accessible :charge_type, :charge_cents, :currency
  
  
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  has_many :video_sessions, :inverse_of => :klu
  
  validates :user_id, :presence => true
  validates :title, :length => { :minimum => 2, :maximum => 150 }
  validates :tag_list, :presence => true 
  #:length => { 
  #                          :minimum => 2,
  #                          :maximum => 10, 
  #                          :too_short => '.must_supply_tags',
  #                          :too_long  => '.must_supply_tags'
  #                          }
    

  scope :published, where("published=?", true)
  
  after_create :generate_notification
  
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
    has charge_cents, :type => :integer
    has updated_at
    has created_at
    #has tags(:id), :as => :tag_ids
    #has tags(:id), :as => :tagids, :facet => true
    where "published = true"
  end
  
  
  def published?
    return true if self.published
  end
  
  def get_charge_type_as_integer
    
    if self.charge_type == 'fix' 
      return 3
    elsif self.charge_type == 'minute'
      return 2
    end
    
    return 1
  end
  
  #TODO dummy method for free minutes
  def free_time
    return 5
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
    
    # best matches: same category - exakt same tags
    results = klu_class.search( :with => { :category_id => cat.id}, 
                            :without => { :user_id => self.user_id },
                            :conditions => { :tag_name => self.tags.map { |t| t.name } }
                           )
                           
    if results.total_entries < 1
      Rails.logger.debug("Klu#complementaries - no results in first case")
      
      # quite good match: tagged with one or more of self.tags
      results = klu_class.search( build_tag_list_arguments,
                                :without => { :user_id => self.user_id },
                                :match_mode => :extended
                                 )
    else
      Rails.logger.debug("Klu#complementaries - results in first case")
    end
    
    if results.total_entries < 1
      Rails.logger.debug("Klu#complementaries - no results in first and second case - trying text-search")
      # the worst - quite broad matches - simply on text-comparison
      results = klu_class.search( "#{self.title} #{self.description}", :star => true, :without => { :user_id => self.user_id }  )
    else
       Rails.logger.debug("Klu#complementaries - no results in second case")
    end
    
    results
    
  end
  
  def rating_score
    count = self.ratings.count
    average = 0
    sum = 0
    self.ratings.each { |r| sum += r.score }
    average = sum / count if count > 0
    average
  end
  
  
  private
  # generates argument list for @tag_name 
  # to look up in other klus : e.g. (@tag_name foobar | @tag_name dumbazz | @tag_name fnord)
  #
  def build_tag_list_arguments
    self.tags.collect { |t| "@tag_name #{t.name}" }.join("|") 
  end
  
  protected 
  
  def generate_notification
    if self.published == true
      self.user.follower.each do |follower|
        if follower.account.prefs.inform_of_friends == true
          Notification::NewKluuu.create(:user => follower, :other => self.user, :klu => self)
        end
      end
    end
  end
  
end
