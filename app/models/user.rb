# Attributes:
# * id [integer, primary, not null] - primary key
# * about [text] - TODO: document me
# * avatar_uid [string] - TODO: document me
# * created_at [datetime, not null] - creation time
# * current_sign_in_at [datetime] - Devise Trackable module
# * current_sign_in_ip [string] - Devise Trackable module
# * email [string, default="", not null]
# * encrypted_password [string, default="", not null] - Devise encrypted password
# * firstname [string] - TODO: document me
# * guest [boolean] - TODO: document me
# * header_uid [string] - TODO: document me
# * last_request_at [datetime] - TODO: document me
# * last_sign_in_at [datetime] - Devise Trackable module
# * last_sign_in_ip [string] - Devise Trackable module
# * lastname [string] - TODO: document me
# * provider [string] - used by oauth2
# * remember_created_at [datetime] - Devise Rememberable module
# * reset_password_sent_at [datetime] - Devise Recoverable module
# * reset_password_token [string] - Devise Recoverable module
# * sign_in_count [integer, default=0] - Devise Trackable module
# * slug [text] - TODO: document me
# * timezone [string] - TODO: document me
# * uid [string] - used by oauth2
# * updated_at [datetime, not null] - last update time
# * website [string] - TODO: document me
class User < ActiveRecord::Base

  # make `url_for` available in `details_for`
  include Rails.application.routes.url_helpers

  PRIOTZ = Regexp.new(Settings.priority_timezones)
  
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  has_many :comments, dependent: :destroy
  has_many :messages, dependent: :destroy

  has_many :venues # as owner
  has_many :participations, dependent: :destroy
  has_many :participating_venues, through: :participations, source: :venue
  has_many :reminders, dependent: :destroy

  dragonfly_accessor :header do
    default Rails.root.join('app/assets/images/defaults/user-header.jpg')
  end
  dragonfly_accessor :avatar do
    default Rails.root.join('app/assets/images/defaults/user-avatar.jpg')
  end

  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # see config/initializers/warden.rb for overwritten
  # callbacks in case of authentication or logout
  # to set the default online/offline/busy - state of user
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable #, :timeoutable

  validates :email, uniqueness: true, presence: true
  validates :firstname, presence: true, length: { minimum: 1, maximum: 100 }
  validates :lastname, presence: true, length: { minimum: 1, maximum: 100 }
  validates :slug, presence: true
  validates_acceptance_of :accept_terms_of_use
  validates_inclusion_of :timezone, in: ActiveSupport::TimeZone.zones_map(&:name),
    allow_nil: true

  include PgSearch
  multisearchable against: [:firstname, :lastname]
  pg_search_scope :search, against: [:firstname, :lastname],
    using: { tsearch: { prefix: true } },
    ignoring: :accents

  def name
    "#{firstname} #{lastname}"
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  def about_as_plaintext
    Nokogiri::HTML(about).text
  end

  class << self

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth[:provider], :uid => auth[:uid]).first
      unless user
        user = User.create( lastname: auth[:extra][:raw_info][:last_name],
                            firstname: auth[:extra][:raw_info][:first_name],
                            provider: auth[:provider],
                            website: auth[:info][:urls][:Facebook],
                            uid: auth[:uid],
                            email: auth[:info][:email],
                            password: Devise.friendly_token[0,20] )
      end
      user
    end
  end

  def details_for(talk)
    {
      id: id,
      name: name,
      role: role_for(talk),
      image: avatar.thumb('100x100#nw').url,
      stream: "t#{talk.id}-u#{id}",
      channel: "/t#{talk.id}/u#{id}",
      link: url_for(controller: 'users',
                    action: 'show',
                    id: id,
                    only_path: true)
    }
  end

  def role_for(talk)
    return :host if self == talk.user
    return :guest if talk.guests.include?(self)
    # TODO: check resulting db queries, maybe use eager loading
    # TODO: Returning :participant is a temporary implementation. It is not yet
    # dediced how to proceed since we removed the explicit participantion.
    return :participant unless guest?
    :listener
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
    !!(email =~ /@voicerepublic.com$/)
  end

  def remembers?(model)
    reminders.exists?( rememberable_id: model.id,
                       rememberable_type: model.class.name )
  end

end
