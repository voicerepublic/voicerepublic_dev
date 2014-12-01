# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * rememberable_id [integer] - belongs to :rememberable (polymorphic)
# * rememberable_type [string] - belongs to :rememberable (polymorphic)
# * updated_at [datetime] - last update time
# * user_id [integer] - belongs to :user
class Reminder < ActiveRecord::Base
  belongs_to :user
  belongs_to :rememberable, polymorphic: true

  validates :user, presence: true

  # TODO http://stackoverflow.com/questions/26380084
  scope :talks, -> { where(rememberable_type: 'Talk') }
end
