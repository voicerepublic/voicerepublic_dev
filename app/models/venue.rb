class Venue < ActiveRecord::Base

  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]

  belongs_to :user
  has_many :talks

  validates :name, :user_id, presence: true

  serialize :options

  # provides easier access to options
  # and allows strings as keys in yaml
  def opts
    OpenStruct.new(options)
  end

  private

  def slug_candidates
    [ :name, [:id, :name] ]
  end

end
