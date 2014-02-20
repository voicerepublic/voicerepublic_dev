class Message < ActiveRecord::Base

  attr_accessible :content

  belongs_to :user
  belongs_to :talk

  validates :user, :talk, presence: true

end
