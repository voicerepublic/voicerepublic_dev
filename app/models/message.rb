# Attributes:
# * id [integer, primary, not null] - primary key
# * content [text] - TODO: document me
# * created_at [datetime] - creation time
# * talk_id [integer] - belongs to :talk
# * updated_at [datetime] - last update time
# * user_id [integer] - belongs to :user
class Message < ApplicationRecord

  include LifecycleEmitter

  belongs_to :user
  belongs_to :talk

  validates :talk, presence: true

  after_create :publish_to_talk

  def as_text
    attrs = {
      user_name: user.name,
      created_at: I18n.l(created_at, format: :timeonly),
      content: content
    }
    I18n.t('messages.as_text', attrs)
  end

  def extended_attributes
    {
      # regular
      id: id,
      content: content,
      created_at: created_at,
      # extended
      user_name: user.name,
      user_image_url: user.avatar_image_url,
      user_image_alt: user.image_alt
    }
  end

  def publish_to_talk
    return if Rails.env.test?

    Faye.publish_to talk.channel, event: 'message', message: extended_attributes
  end

end
