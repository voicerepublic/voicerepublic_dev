class Comment < ActiveRecord::Base

  attr_accessible :content
  
  # FIXME this is a security hack
  attr_accessible :user_id, :article_id

  belongs_to :article
  belongs_to :user

  delegate :venue, to: :article, prefix: true

  default_scope { order('created_at DESC') }

  validates :user, presence: true
  validates :article, presence: true
  validates :content, presence: true

end
