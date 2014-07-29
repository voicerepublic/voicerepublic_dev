# Attributes:
# * id [integer, primary, not null] - primary key
# * commentable_id [integer] - belongs to :commentable
# * commentable_type [string] - belongs to :commentable
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * updated_at [datetime, not null] - last update time
# * user_id [integer, not null] - belongs to :user
class Comment < ActiveRecord::Base

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  scope :ordered, ->{ order('created_at DESC') }

  validates :user, :commentable, :content, presence: true

end
