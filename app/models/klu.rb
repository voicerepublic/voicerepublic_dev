# Attributes:
# * id [integer, primary, not null] - primary key
# * available_at_times [string] - TODO: document me
# * category_id [integer] - belongs to :category
# * charge_cents [integer, default=0] - TODO: document me
# * charge_type [string, default="free"] - TODO: document me
# * created_at [datetime, not null] - creation time
# * currency [string] - TODO: document me
# * description [text] - TODO: document me
# * published [boolean] - TODO: document me
# * title [string]
# * type [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class Klu < ActiveRecord::Base
  
  attr_accessible :available_at_times, :category_id, :category, :description, :published, :title, :type, :user_id, :tag_list, :uses_status
  attr_accessible :charge_type, :charge_cents, :currency
  
  acts_as_taggable
  
  belongs_to :user
  belongs_to :category
  has_many :video_sessions, :inverse_of => :klu
  
  has_many :notifications, :class_name => "Notification::Base", :dependent => :destroy, :foreign_key => :klu_id
  has_many :venue_klus, :class_name => "VenueKlu", :dependent => :destroy, :foreign_key => :klu_id
  has_many :comments, :as => :commentable, :dependent => :destroy
  
  validates :user_id, :presence => true
  validates :title, :presence => true
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
  before_save :clean_taglist # prevent vollpfosten from adding hash-tag to tag-names
  
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
  
  def allow_anonymous_calls?
    user.account.prefs.anonymous_calls == "1"
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
  
  
  def complementaries(limit=nil)
    cat = self.category
    tags = self.tag_list
    klu_class = self.instance_of?(Kluuu) ? NoKluuu : Kluuu
    
    # best matches: same category - 
    # - exakt same tags
    # - same category
    # - complementary class klu => no_klu
    # first-case
    @results = klu_class.search( :with => { :category_id => cat.id}, 
                            :without => { :user_id => self.user_id },
                            :per_page => limit || 10,
                            :conditions => { :tag_name => self.tags.map { |t| t.name } }
                           )
    Rails.logger.info("Klu#complementaries - results first case #{@results.count}")
                           
    if @results.flatten.count < 2
      Rails.logger.info("Klu#complementaries - few results in first case")
      # quite good match: 
      # - tagged with one or more of self.tags
      # - same category
      # second-case
      temp_result = klu_class.search( :conditions => { :tag_name => build_tag_list_arguments },
                                  :with => { :category_id => cat.id}, 
                                  :per_page => limit || 10,
                                  :without => { :user_id => self.user_id }
                                 )
      temp_result.each { |i| @results.push(i) }
      Rails.logger.info("Klu#complementaries - results in second case - #{temp_result.count} - overall: #{@results.flatten.count}")                           
    else
      Rails.logger.info("Klu#complementaries - found results #{@results.flatten.count} in first case")
    end
    
    if @results.flatten.count < 3
      Rails.logger.info("Klu#complementaries - few results in second case")
      # quite ok match: 
      # - minimum one tag
      # - complementary class klu => no_klu
      # third-case
      temp_result = klu_class.search( :conditions => { :tag_name => build_tag_list_arguments },
                                  :per_page => limit || 10,
                                  :without => { :user_id => self.user_id }
                                 )
      temp_result.each { |i| @results.push(i) }
      Rails.logger.info("Klu#complementaries - results in third case #{temp_result.count} - overall: #{@results.flatten.count}")                         
    else
      Rails.logger.info("Klu#complementaries - found results #{@results.flatten.count} in second case")
    end
    
    if @results.flatten.count < 1
      Rails.logger.info("Klu#complementaries - no results in third case - trying text-search")
      # the worst - quite broad matches - simply on text-comparison
      # forth-case
      temp_result = Klu.search( "#{self.title} #{self.description}", 
                                :star => true, 
                                :without => { :user_id => self.user_id }  
                              )
      temp_result.each { |i| @results.push(i) }
      Rails.logger.info("Klu#complementaries - results now in text-search: #{temp_result.count}")
    else
      Rails.logger.info("Klu#complementaries - found results: #{@results.flatten.count} in third case")
    end
    
    if @results.flatten.count < 1
      # even more worse:
      # simply fetch some entries in given category
      # independent of class
      Rails.logger.info("Klu#complementaries - no results in fourth case - trying category")
      temp_result = Klu.search(:with => { :category_id => cat.id },
                                :per_page => limit || 10,
                                :without => { :user_id => self.user_id } )
      temp_result.each { |i| @results.push(i) }
      Rails.logger.info("Klu#complementaries - results now of category: #{temp_result.count}")
    end
    
    @results.flatten.uniq
    
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
    self.tags.collect { |t| t.name }.join("|") 
  end
 
  def clean_taglist
    self.tag_list.each { |i| i.gsub!('#','') }
    self.tag_list.each { |i| i.gsub!(' ', '_') }
  end
  
  protected 
  
  def generate_notification
    if self.published == true
      self.user.follower.each do |follower|
        if follower.account.prefs.inform_of_friends == "1" || true
          Notification::NewKluuu.create(:user => follower, :other => self.user, :klu => self)
        end
      end
    end
  end
  
end
