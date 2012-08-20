class User < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :password, :password_confirmation, :remember_me
  attr_accessible :email, :firstname, :lastname #:encrypted_password,
  attr_accessible :provider, :uid
  
  validates :email, :uniqueness => true, :presence => true
  validates :firstname, :presence => true
  validates :lastname, :presence => true
  validates :slug, :presence => true
  
  ###### instance methods
  
  def name
    "#{firstname} #{lastname}"
  end
  
  
  ######  class methods
  
  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    unless user
      user = User.create(lastname:auth.extra.raw_info.last_name,
                         firstname:auth.extra.raw_info.first_name,
                         provider:auth.provider,
                         uid:auth.uid,
                         email:auth.info.email,
                         password:Devise.friendly_token[0,20]
                         )
    end
    user
  end  
  
  
  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
    data = access_token.info
    user = User.where(:email => data["email"]).first
    unless user
        user = User.create(lastname:data["last_name"],
              firstname:data["first_name"],
             email:data["email"],
             password:Devise.friendly_token[0,20]
            )
    end
    user
  end
  
  #def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
  #  data = auth.info
  #  user = User.where(:email => data["email"]).first
  #  unless user
  #      user = User.create(lastname:data["last_name"],
  #            firstname:data["first_name"],
  #           email:data["email"],
  #           password:Devise.friendly_token[0,20]
  #          )
  #  end
  #  user
  #end
end
