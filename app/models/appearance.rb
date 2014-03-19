# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * talk_id [integer] - belongs to :talk
# * updated_at [datetime] - last update time
# * user_id [integer] - belongs to :user
class Appearance < ActiveRecord::Base

  attr_accessible :user_id

  validates :user, :talk, presence: true

  belongs_to :user
  belongs_to :talk

end
