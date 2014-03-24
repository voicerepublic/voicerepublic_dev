# Attributes:
# * id [integer, primary, not null] - primary key
# * content [text] - TODO: document me
# * created_at [datetime] - creation time
# * talk_id [integer] - belongs to :talk
# * updated_at [datetime] - last update time
# * user_id [integer] - belongs to :user
class Message < ActiveRecord::Base

  attr_accessible :content

  belongs_to :user
  belongs_to :talk

  validates :user, :talk, presence: true

  def as_text
    "#{created_at} #{user.name}:\n#{content}\n"
  end
  
end
