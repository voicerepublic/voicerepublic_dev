class Comment < ActiveRecord::Base

  attr_accessible :content
  
  belongs_to :article
  belongs_to :user

  delegate :venue, to: :article, prefix: true

  default_scope { order('created_at DESC') }

  validates :user, :article, :content, presence: true

end
