# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
# * venue_id [integer] - belongs to :venue
class Participation < ActiveRecord::Base

  belongs_to :venue
  belongs_to :user

  validates_uniqueness_of :venue_id, scope: :user_id
  validates :venue, :user, presence: true

end
