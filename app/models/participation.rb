class Participation < ActiveRecord::Base

  attr_accessible :venue_id, :user_id

  belongs_to :venue
  belongs_to :user

  validates_uniqueness_of :venue_id, :scope => :user_id

end
