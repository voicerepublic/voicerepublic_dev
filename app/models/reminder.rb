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
  validates :user_id, uniqueness: { scope: [:rememberable_id, :rememberable_type] }

  class << self
    def find_by_user_and_talk(user, talk)
      where(user_id: user.id,
            rememberable_id: talk.id,
            rememberable_type: 'Talk').first
    end
  end

end
