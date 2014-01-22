class Participation < ActiveRecord::Base

  belongs_to :venue
  belongs_to :user

  validates_uniqueness_of :venue_id, :scope => :user_id
  validates :venue, :user, presence: true

end
