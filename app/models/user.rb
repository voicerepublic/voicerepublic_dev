# Attributes:
# * id [integer, primary, not null] - primary key
# * about [text] - TODO: document me
# * available [string] - TODO: document me
# * avatar_uid [string] - TODO: document me
# * created_at [datetime, not null] - creation time
# * current_sign_in_at [datetime] - Devise Trackable module
# * current_sign_in_ip [string] - Devise Trackable module
# * email [string, default="", not null]
# * encrypted_password [string, default="", not null] - Devise encrypted password
# * firstname [string] - TODO: document me
# * guest [boolean] - TODO: document me
# * header_uid [string] - TODO: document me
# * image_content_type [string] - TODO: document me
# * image_file_name [string] - TODO: document me
# * image_file_size [integer] - TODO: document me
# * image_updated_at [datetime] - TODO: document me
# * last_request_at [datetime] - TODO: document me
# * last_sign_in_at [datetime] - Devise Trackable module
# * last_sign_in_ip [string] - Devise Trackable module
# * lastname [string] - TODO: document me
# * provider [string] - TODO: document me
# * remember_created_at [datetime] - Devise Rememberable module
# * reset_password_sent_at [datetime] - Devise Recoverable module
# * reset_password_token [string] - Devise Recoverable module
# * sign_in_count [integer, default=0] - Devise Trackable module
# * slug [text] - TODO: document me
# * timezone [string] - TODO: document me
# * uid [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * website [string] - TODO: document me
class User < ActiveRecord::Base

  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders]

  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :email, :firstname, :lastname
  attr_accessible :provider, :uid, :last_request_at, :available
  attr_accessible :accept_terms_of_use, :guest, :header, :avatar, :about
  attr_accessible :timezone, :website

  has_many :comments, dependent: :destroy

  has_many :venues # as owner
  has_many :participations
  has_many :participating_venues, through: :participations, source: :venue

  dragonfly_accessor :header do
    default Rails.root.join('app/assets/images/defaults/user-header.jpg')
  end
  dragonfly_accessor :avatar do
    default Rails.root.join('app/assets/images/defaults/user-avatar.jpg')
  end

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
  validates_associated :account

  include PgSearch
  multisearchable against: [:firstname, :lastname]
  pg_search_scope :search, against: [:firstname, :lastname],
    using: { tsearch: { prefix: true } },
    ignoring: :accents

  def name
    if guest
      I18n.t('sign_in_or_register')
    else
      "#{firstname} #{lastname}"
    end
  end

  def email_with_name
    "#{name} <#{email}>"
  end

  class << self

    def find_for_facebook_oauth(auth, signed_in_resource=nil)
      user = User.where(:provider => auth.provider, :uid => auth.uid).first
      unless user
        user = User.create( lastname: auth.extra.raw_info.last_name,
                            firstname: auth.extra.raw_info.first_name,
                            provider: auth.provider,
                            uid: auth.uid,
                            email: auth.info.email,
                            password: Devise.friendly_token[0,20] )
      end
      user
    end

    def find_for_google_oauth2(auth, signed_in_resource=nil)
      data = auth.info
      user = User.where(:provider => auth.provider, :uid => auth.uid).first

      unless user
        user = User.create( lastname: data["last_name"],
                            firstname: data["first_name"],
                            email: data["email"],
                            provider: auth.provider,
                            uid: auth.uid,
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
      image: avatar.url,
      stream: "t#{talk.id}-u#{id}"
    }
  end

  def role_for(talk)
    return :host if self == talk.user
    return :guest if talk.guests.include?(self)
    # TODO: check resulting db queries, maybe use eager loading
    return :participant if talk.venue.users.include?(self)
    :listener
  end

  # helper for console
  def set_password!(passwd)
    self.password = self.password_confirmation = passwd
    save!
  end

  # we'll use `text` here, which plays nice with select2
  def for_select
    { id: id, text: name, img: avatar.url }
  end

end
