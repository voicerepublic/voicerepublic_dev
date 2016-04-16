class Organization < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :devices, dependent: :nullify
  # nullify will render devices useless unless reset manually

  validates :description, length: { maximum: Settings.limit.text }
  validates :name, :slug, presence: true
  validates :slug, length: { minimum: 5 }
  validates :slug, format: { with: /\A[\w-]+\z/,
                             message: I18n.t('validation.bad_chars_in_slug') }

  before_save :process_description, if: :description_changed?

  acts_as_taggable

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/organization-image.jpg')
  end

  def process_description
    self.description_as_html = MD2HTML.render(description)
    self.description_as_text = MD2TEXT.render(description)
  end

end
