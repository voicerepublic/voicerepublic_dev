class Job < ActiveRecord::Base

  include ActiveModel::Transitions

  belongs_to :context, polymorphic: true

  scope :ordered, -> { order('created_at ASC') }

  serialize :details

  attr_accessor :event

  state_machine auto_scopes: true do
    state :pending
    state :running
    state :completed

    event :start, timestamp: :started_at do
      transitions from: :pending, to: :running
    end
    event :complete, timestamp: :completed_at do
      transitions from: :running, to: :completed
    end
  end

  def event_fired(current_state, new_state, event)
    names = [[:exit, current_state],
             [:enter, new_state],
             [:on, event]].map { |n| n * '_' }
    names.each do |name|
      if respond_to?(name)
        send(name)
      end
    end
  end

end
