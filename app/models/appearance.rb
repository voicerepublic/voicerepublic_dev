class Appearance < ActiveRecord::Base

  attr_accessible :user_id

  validates :user, :talk, presence: true

  belongs_to :user
  belongs_to :talk

end
