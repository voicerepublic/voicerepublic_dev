# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * talk_id [integer] - belongs to :talk
# * updated_at [datetime] - last update time
# * user_id [integer] - belongs to :user
class Appearance < ApplicationRecord

  validates :user, :talk, presence: true

  belongs_to :user
  belongs_to :talk

end
