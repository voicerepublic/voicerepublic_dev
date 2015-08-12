# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
# * series_id [integer] - belongs to :series
class Participation < ActiveRecord::Base

  belongs_to :series
  belongs_to :user

  validates_uniqueness_of :series_id, scope: :user_id
  validates :series, :user, presence: true

end
