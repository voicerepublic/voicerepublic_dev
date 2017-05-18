class Event < ActiveRecord::Base

  belongs_to :source, polymorphic: true

  scope :ordered, -> { order('created_at DESC') }
  scope :limited, -> { limit(33) }

end
