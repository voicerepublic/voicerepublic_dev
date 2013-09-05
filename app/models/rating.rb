class Rating < ActiveRecord::Base
  MAX = 5

  attr_accessible :content, :rateable_id, :user_id, :rateable_type, :score

  belongs_to :rateable, :polymorphic => true
  belongs_to :user

  validates :content, :presence => true
  validates :user_id, :presence => true
  validates :rateable_id, :presence => true
  validates :rateable_type, :presence => true
  validates :score, :inclusion => {  :in => 0..5 }
end
