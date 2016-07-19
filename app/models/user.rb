# Attributes:
# * id [integer, primary, not null] - primary key
# * about [text, default=""] - TODO: document me
# * authentication_token [string] - Devise Token authenticable module
# * avatar_uid [string] - TODO: document me
# * confirmation_sent_at [datetime] - Devise Confirmable module
# * confirmation_token [string] - Devise Confirmable module
# * confirmed_at [datetime] - Devise Confirmable module
# * created_at [datetime, not null] - creation time
# * current_sign_in_at [datetime] - Devise Trackable module
# * current_sign_in_ip [string] - Devise Trackable module
# * default_series_id [integer] - belongs to :default_series
# * email [string, default="", not null]
# * encrypted_password [string, default="", not null] - Devise encrypted password
# * firstname [string] - TODO: document me
# * header_uid [string] - TODO: document me
# * last_request_at [datetime] - TODO: document me
# * last_sign_in_at [datetime] - Devise Trackable module
# * last_sign_in_ip [string] - Devise Trackable module
# * lastname [string] - TODO: document me
# * penalty [float, default=1.0] - TODO: document me
# * provider [string] - used by oauth2
# * remember_created_at [datetime] - Devise Rememberable module
# * reset_password_sent_at [datetime] - Devise Recoverable module
# * reset_password_token [string] - Devise Recoverable module
# * sign_in_count [integer, default=0] - Devise Trackable module
# * slug [text] - TODO: document me
# * summary [string] - TODO: document me
# * timezone [string] - TODO: document me
# * uid [string] - used by oauth2
# * unconfirmed_email [string] - Devise Confirmable module
# * updated_at [datetime, not null] - last update time
# * website [string] - TODO: document me
class User < ActiveRecord::Base

  include LifecycleEmitter

  # this makes `url_for` available for use in `details_for`
  include Rails.application.routes.url_helpers

  # Send Welcome Instructions and Personal Welcome Mail
  include Welcomed

  PRIOTZ = Regexp.new(Settings.priority_timezones)

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  # TODO discuss if destroing these makes sense
  # we might end up with half of a dialog.
  has_many :messages, dependent: :destroy

  has_many :venues, dependent: :destroy
  has_many :series, dependent: :destroy # as owner
  has_many :talks, through: :series
  has_many :participations, dependent: :destroy
  has_many :participating_series, through: :participations, source: :series
  has_many :reminders, dependent: :destroy
  # TODO clarify how to deal with deletions
  has_many :purchases, foreign_key: :owner_id, dependent: :nullify
  has_one :welcome_transaction, as: :source

  belongs_to :default_series, class_name: 'Series', dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships

  acts_as_taggable

  dragonfly_accessor :header do
    default Rails.root.join('app/assets/images/defaults/user-header.jpg')
  end
  dragonfly_accessor :avatar do
    default Rails.root.join('app/assets/images/defaults/user-avatar.jpg')
  end

  acts_as_token_authenticatable

  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable

  validates :email, uniqueness: true, length: { maximum: Settings.limit.varchar }
  validates :firstname, presence: true, length: { minimum: 1, maximum: 100 }
  validates :lastname, presence: true, length: { minimum: 1, maximum: 100 }
  validates :summary, length: { maximum: Settings.limit.string }
  validates :about, length: { maximum: Settings.limit.text }
  validates :slug, presence: true

  validates :slug, length: { minimum: 5,
                             maximum: Settings.limit.varchar }
  validates :slug, format: { with: /\A[\w-]+\z/,
                             message: I18n.t('validation.bad_chars_in_slug') }

  validates :website, length: { maximum: Settings.limit.varchar }

  validates_acceptance_of :accept_terms_of_use
  # TODO check if this works, especcialy the allow_nil, and does allow_nil make sense?
  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.zones_map.keys },
            allow_nil: true

  # WARNING: Do not use after_save hooks in the 'user' model that will
  # save the model. The reason is that the Devise confirmable_token
  # might be reset mid-transaction.
  before_save :process_about, if: :about_changed?
  before_save :set_image_alt, unless: :image_alt?
  before_create :build_and_set_default_series
  after_save :generate_flyers!, if: :generate_flyers?

  # for the same reason this has to happen in 2 steps
  before_create :build_welcome_transaction
  after_create :process_welcome_transaction
  after_create :add_default_pins
  after_create :create_first_organization

  before_save :normalize_website, if: :website_changed?
  before_save :normalize_twitter, if: :twitter_changed?
  before_save :normalize_facebook, if: :facebook_changed?

  include PgSearch
  multisearchable against: [:firstname, :lastname]
  pg_search_scope :search, against: [:firstname, :lastname],
    using: { tsearch: { prefix: true } },
    ignoring: :accents

  def build_and_set_default_series
    attrs = Settings.default_series_defaults[I18n.locale].to_hash
    build_default_series(attrs.merge(user: self))
  end

  def name
    "#{firstname} #{lastname}"
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  class << self
    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth[:provider], :uid => auth[:uid]).first
      unless user
        user = User.new( lastname: auth[:extra][:raw_info][:last_name],
                         firstname: auth[:extra][:raw_info][:first_name],
                         provider: auth[:provider],
                         website: auth[:info][:urls][:Facebook],
                         uid: auth[:uid],
                         email: auth[:info][:email],
                         password: Devise.friendly_token[0,20] )
        user.confirm!
      end

      user.reload
    end
  end

  def details
    {
      name: name,
      url: self_url,
      image_url: avatar.thumb('36x36').url
    }
  end

  def details_for(talk)
    {
      id: id,
      name: name,
      role: role_for(talk),
      image: avatar.thumb('100x100#nw').url,
      stream: "t#{talk.id}-u#{id}",
      downmsg: "/t#{talk.id}/u#{id}",
      upmsg: "/live/up/t#{talk.id}/u#{id}",
      link: url_for(controller: 'users',
                    action: 'show',
                    id: to_param,
                    only_path: true)
    }
  end

  def role_for(talk)
    return :host if self == talk.user
    return :guest if talk.guests.include?(self)
    # TODO: check resulting db queries, maybe use eager loading
    # TODO: Returning :participant is a temporary implementation. It is not yet
    # dediced how to proceed since we removed the explicit participantion.
    :participant
  end

  # helper for console
  def set_password!(passwd)
    self.password = self.password_confirmation = passwd
    save!
  end

  # we'll use `text` here, which plays nice with select2
  def for_select
    { id: id, text: name, img: avatar.thumb('50x50#nw').url }
  end

  def insider?
    !!(email =~ /@(voicerepublic|example)\.com$/)
  end

  def developer?
    Settings.developers.include?(email)
  end

  def remembers?(model)
    reminders.find_by( rememberable_id: model.id,
                       rememberable_type: model.class.name )
  end

  def generate_flyers?
    firstname_changed? or lastname_changed?
  end

  # TODO check if `talks.reload` can be replaced with `talks(true)`
  def generate_flyers!
    series.reload
    talks.reload.each do |talk|
      Delayed::Job.enqueue GenerateFlyer.new(id: talk.id), queue: 'audio'
    end
  end

  # TODO rewrite this as `has_many :series_without_default, conditions: ...`
  def series_without_default
    series.where.not(id: default_series_id)
  end

  def set_penalty!(penalty, deep=true)
    self.penalty = penalty
    save!
    return unless deep
    series.each { |series| series.set_penalty!(penalty) }
  end

  def is_pro?
    purchases.count > 0
  end

  # series might at some point be renamed to series
  # hence it might be a good idea to call this method
  # differently
  def list_of_series
    series.inject({}) { |h, v| h.merge v.id => v.title }
  end

  def self_url
    Rails.application.routes.url_helpers.user_url(self)
  end

  def venue_default_name
    "Venue of %s" % name
  end

  def website_url
    website.blank? ? nil : 'http://' + website
  end

  def twitter_url
    twitter.blank? ? nil : 'https://twitter.com/' + twitter
  end

  def facebook_url
    facebook.blank? ? nil : 'https://www.facebook.com/' + facebook
  end

  def pin_map
    Hash[Talk.remembered_by(self).pluck(:id, 'reminders.id')]
  end

  private

  def normalize_website
    self.website = website.sub(/^https?:\/\//, '')
  end

  def normalize_twitter
    self.twitter = twitter.sub(/^@/, '').
                   sub(/^https?:\/\/twitter\.com\//, '')
  end

  def normalize_facebook
    self.facebook = facebook.sub(/^https?:\/\/www\.facebook\.com\//, '')
  end

  def process_about
    self.about_as_html = MD2HTML.render(about)
    self.about_as_text = MD2TEXT.render(about)
  end

  def set_image_alt
    self.image_alt = name
  end

  def process_welcome_transaction
    welcome_transaction.process!
  end

  def add_default_pins
    slugs = Settings.default_pins
    return if slugs.nil? or slugs.empty?

    slugs.each do |slug|
      talk = Talk.find_by(slug: slug)
      next if talk.nil?
      Reminder.create user: self, rememberable: talk
    end
  end

  def create_first_organization
    organizations.any? or organizations.create name: name
  end

  protected

  def reconfirmation_required?
    provider != 'facebook' && super
  end

end
