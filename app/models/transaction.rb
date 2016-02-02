# Attributes:
# * id [integer, primary, not null] - primary key
# * created_at [datetime] - creation time
# * details [text] - TODO: document me
# * failed_at [datetime] - TODO: document me
# * processed_at [datetime] - TODO: document me
# * source_id [integer] - belongs to :source (polymorphic)
# * source_type [string] - belongs to :source (polymorphic)
# * state [string] - TODO: document me
# * type [string] - TODO: document me
# * updated_at [datetime] - last update time
class Transaction < ActiveRecord::Base

  include ActiveModel::Transitions

  belongs_to :source, polymorphic: true

  serialize :details

  state_machine do
    state :pending
    state :processing
    state :closed
    state :failed
    event :start do
      transitions from: :pending, to: :processing
    end
    event :close, timestamp: :processed_at do
      transitions from: :processing, to: :closed
    end
    event :abort, timestamp: :failed_at do
      transitions from: :processing, to: :failed
    end
  end

  def process!
    raise 'not implemented, use a subclass'
  end

  private

  # newschool
  def event_fired(*args)
    Simon.says x: 'transaction_transitions',
               event: 'transaction_transition',
               details: message_details.merge(event: args)
  end

  # should be overwritten in subclasses
  def message_details
    attributes
  end

end
