# Attributes:
# * id [integer, primary, not null] - primary key
# * content [text] - TODO: document me
# * created_at [datetime] - creation time
# * talk_id [integer] - belongs to :talk
# * updated_at [datetime] - last update time
# * user_id [integer] - belongs to :user
class Message < ActiveRecord::Base

  belongs_to :user
  belongs_to :talk

  validates :talk, presence: true

  def as_text
    attrs = {
      user_name: user.name,
      created_at: I18n.l(created_at, format: :timeonly),
      content: content
    }
    I18n.t('messages.as_text', attrs)
  end

end
