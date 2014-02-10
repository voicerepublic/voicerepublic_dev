# Attributes:
# * id [integer, primary, not null] - primary key
# * article_id [integer, not null] - belongs to :article
# * commentable_id [integer] - TODO: document me
# * commentable_type [string] - TODO: document me
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
# * user_id [integer, not null] - belongs to :user
class Comment < ActiveRecord::Base

  attr_accessible :content
  
  belongs_to :article
  belongs_to :user

  delegate :venue, to: :article, prefix: true

  default_scope { order('created_at DESC') }

  validates :user, :article, :content, presence: true

end
