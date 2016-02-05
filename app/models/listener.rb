class Listener < ActiveRecord::Base

  belongs_to :talk
  belongs_to :user

  validates :talk, :session, presence: true

end
