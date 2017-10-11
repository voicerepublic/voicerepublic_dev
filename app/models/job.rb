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
    state :suspended

    event :start, timestamp: :started_at do
      transitions from: :pending, to: :running
    end
    event :complete, timestamp: :completed_at do
      transitions from: :running, to: :completed
    end
    event :failed do
      transitions from: [:pending, :running], to: :suspended
    end
    event :reset do
      transitions from: [:running, :suspended],
                  to: :pending, on_transition: :on_reset
    end
  end

  def on_reset
    # not implemented
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

  # to be used on console
  def self.list
    self.ordered.each do |j|
      puts '%-4s %-10s %-30s %-10s %-4s' %
           [j.id, j.state, j.type, j.context_type, j.context_id]
    end
    nil
  end

end
