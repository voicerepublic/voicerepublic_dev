class Article < ActiveRecord::Base

  acts_as_paranoid

  has_many :comments, dependent: :destroy
  belongs_to :venue
  belongs_to :user

  delegate :user, to: :venue, prefix: true

  attr_accessible :content

  validates :venue, :user, :content, :presence => true

end
