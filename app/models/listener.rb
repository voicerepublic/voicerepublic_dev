class Listener < ActiveRecord::Base

  belongs_to :talk
  belongs_to :user

  validates :talk, :session_token, presence: true

end
