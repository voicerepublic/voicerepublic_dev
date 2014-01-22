# http://stackoverflow.com/questions/2529990/activerecord-date-format
class Talk < ActiveRecord::Base

  attr_accessor :duration

  # attr_accessible :title, :starts_at, :duration, :record

  belongs_to :venue, :inverse_of => :talks

  validates :venue, :title, :starts_at, :ends_at, presence: true

  before_validation :set_ends_at

  private

  def set_ends_at
    return unless starts_at
    self.ends_at = starts_at + duration.minutes
  end

end
