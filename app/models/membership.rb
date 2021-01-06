class Membership < ApplicationRecord

  belongs_to :user
  belongs_to :organization

  validates :user, :organization, presence: true

end
