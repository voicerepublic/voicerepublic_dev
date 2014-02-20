class Appearance < ActiveRecord::Base

  validates :user, :talk, presence: true

  belongs_to :user
  belongs_to :talk
end
