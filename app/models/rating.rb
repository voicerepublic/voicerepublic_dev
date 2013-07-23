# Attributes:
# * id [integer, primary, not null] - primary key
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * rateable_id [integer] - belongs to :rateable (polymorphic)
# * rateable_type [string] - belongs to :rateable (polymorphic)
# * score [integer, default=0] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
class Rating < ActiveRecord::Base
  attr_accessible :content, :rateable_id, :user_id, :rateable_type, :score
  
  belongs_to :rateable, :polymorphic => true
  belongs_to :user
  
  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :rateable_id, :presence => true
  validates :rateable_type, :presence => true
  validates :score, :inclusion => {  :in => 0..5 }
  
  after_create :generate_notification, :destroy_make_rate_notification
  
  MAX = 5
  
  
  private
  
  def generate_notification
    if rateable.kind_of?(Klu)
      Notification::NewRating.create(:other_id => user.id, :user_id => rateable.user.id, :klu_id => rateable.id, :content => self.content)
    else
      self.logger.error("Rating#generate_notification - wanted to generate NewRating-notification  for type other than 'Klu'")
      raise "generate notification implemented for Klu-type only - change in class Rating"
    end
  end
  
  def destroy_make_rate_notification
    Rails.logger.info("Rating#destroy_make_rate_notification - destroying MakeRate-notification for: user: #{user_id} and #{rateable_id}")
    Notification::MakeRate.where("user_id = ? AND klu_id = ?", user_id, rateable_id ).destroy_all
  end
  
end
