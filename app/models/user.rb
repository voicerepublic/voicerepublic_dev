class User < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  after_create :add_default_user_role
  
  has_many :user_roles, :class_name => "UserRole", :dependent => :destroy
  has_many :bookmarks, :dependent => :destroy
  
  accepts_nested_attributes_for :user_roles, :allow_destroy => true
  
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :trackable, :validatable

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
  
  def is_admin?
    a_id = Role.find_by_name('admin').id
    user_roles.map { |ur| ur.role_id == a_id }.uniq.include?(true)
  end
  
  def has_role?(name)
    user_roles.map { |ur| ur.role.name }.include?(name.to_s)
  end
  
  def role_names
    user_roles.map { |ur| ur.role.name }.join(", ")
  end
  
  def add_role!(name)
    user_roles << UserRole.create(:role_id => Role.find_by_name(name).id)
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
  
  
  def self.find_for_google_oauth2(auth, signed_in_resource=nil)
    data = auth.info
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    #user = User.where(:email => data["email"]).first
    unless user
        user = User.create(lastname:data["last_name"],
              firstname:data["first_name"],
             email:data["email"],
             provider:auth.provider,
             uid:auth.uid,
             password:Devise.friendly_token[0,20]
            )
    end
    user
  end
  
  
  private
 
  def add_default_user_role
    user_roles << UserRole.create({:role_id => Role.find_by_name('user').id})
  end
end
