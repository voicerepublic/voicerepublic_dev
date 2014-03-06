class SocialShare < ActiveRecord::Base
  attr_accessible :request_ip, :user_agent, :user_id, :shareable_id,
    :shareable_type

  belongs_to :shareable, polymorphic: true

  validates :shareable_type, inclusion: %w(talk venue)
end
