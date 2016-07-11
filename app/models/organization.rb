class Organization < ActiveRecord::Base

  DEVICE_NAMING_SCHEMA =
    YAML.load(File.read(Rails.root.join('config/device_naming_schema.yml')))

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :memberships, dependent: :destroy
  has_many :users, through: :memberships
  has_many :devices, dependent: :nullify
  # nullify will put devices into pairable state

  validates :description, length: { maximum: Settings.limit.text }
  validates :name, :slug, presence: true
  validates :slug, length: { minimum: 5 }
  validates :slug, format: { with: /\A[\w-]+\z/,
                             message: I18n.t('validation.bad_chars_in_slug') }

  before_save :process_description, if: :description_changed?

  acts_as_taggable

  def device_names
    devices.order(:paired_at).pluck(:name)
  end

  # failry quickly thrown together logic to facilitate flexible naming
  # succession
  def device_name_suggestion(names=device_names)
    # suggest boring name for first device
    return 'Streamboxx 1' if names.empty?

    last_name = names.last
    # increase numerical postfix
    if md = last_name.match(/(\d+)$/)
      index = md.to_a.last
      return last_name.sub(index, (index.to_i + 1).to_s)
    end
    # try to match custom list
    ranking = DEVICE_NAMING_SCHEMA.sort_by do |sname, dnames|
      - (names & dnames).count
    end
    candidates = (ranking.first.last - names)
    # handle end of list
    return names.first + ' 2' if candidates.empty?
    candidates.first
  end

  dragonfly_accessor :image do
    default Rails.root.join('app/assets/images/defaults/organization-image.jpg')
  end

  def process_description
    self.description_as_html = MD2HTML.render(description)
    self.description_as_text = MD2TEXT.render(description)
  end

end
