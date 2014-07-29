class Reminder < ActiveRecord::Base
  belongs_to :user
  belongs_to :rememberable, polymorphic: true

  validates :user, presence: true
end
