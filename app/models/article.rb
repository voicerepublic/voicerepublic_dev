# Attributes:
# * id [integer, primary, not null] - primary key
# * content [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * deleted_at [datetime] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
# * venue_id [integer] - belongs to :venue
class Article < ActiveRecord::Base

  acts_as_paranoid

  belongs_to :venue
  belongs_to :user

  attr_accessible :content

  validates :venue, :user, :content, :presence => true

end
