class User < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  MAX_IDLE = 10.minutes
  SET_BUSY = 20.minutes
  SET_OFFLINE = 40.minutes
  
  attr_accessible :password, :password_confirmation, :remember_me, :account_attributes
  attr_accessible :email, :firstname, :lastname #:encrypted_password,
  attr_accessible :provider, :uid, :last_request_at, :available
 
  has_many :user_roles, :class_name => "UserRole", :dependent => :destroy
  has_many :roles, :through => :user_roles
  has_many :bookmarks, :dependent => :destroy
  has_many :status_updates, :dependent => :destroy, :order => "created_at DESC"
  has_many :comments, :dependent => :destroy
  has_many :notifications, :class_name => 'Notification::Base'
  has_many :ratings
  
  has_many :klus ,  :dependent => :destroy       # -> base-class
  has_many :no_kluuus,  :dependent => :destroy
  has_many :kluuus, :dependent => :destroy
 
  has_many :sent_messages, :foreign_key => :sender_id, :class_name => 'Message', :dependent => :destroy
  has_many :received_messages, :foreign_key => :receiver_id, :class_name => 'Message', :dependent => :destroy
  
  has_many :followed_relations, :foreign_key => :follower_id, :class_name => 'Follow', :dependent => :destroy
  has_many :follower_relations, :foreign_key => :followed_id, :class_name => 'Follow', :dependent => :destroy  
  has_many :follower, :through => :follower_relations#, :source => :followed 
  has_many :followed, :through => :followed_relations#, :source => :follower 
  
  has_one :account, :dependent => :destroy          # application-account-things
  has_one :balance_account, :dependent => :destroy, :class_name => 'Balance::Account'   # financial things
  
  scope :online, where("available = ? OR available = ?", 'online', 'busy')
  
  accepts_nested_attributes_for :user_roles, :allow_destroy => true 
  accepts_nested_attributes_for :account
  
  after_create :add_default_user_role
  after_create :add_account
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # see config/initializers/warden.rb for overwritten callbacks in case of authentication or logout
  # to set the default online/offline/busy - state of user
  devise :database_authenticatable, :registerable, :omniauthable,
           :recoverable, :rememberable, :trackable, :validatable, :timeoutable

  validates :email, :uniqueness => true, :presence => true
  validates :firstname, :presence => true, :length => { :minimum => 1, :maximum => 100}
  validates :lastname, :presence => true, :length => { :minimum => 1, :maximum => 100}
  validates :slug, :presence => true
  
  ###### instance methods
  
  def name
    "#{firstname} #{lastname}"
  end
  
  def has_role?(name)
    user_roles.map { |ur| ur.role.name }.include?(name.to_s)
  end

  def is_admin?
    has_role?(:admin)
  end
  
  # FIXME : test ist
  def role_names
    user_roles.map { |ur| ur.role.name }.join(", ")
  end
  
  def add_role!(name)
    user_roles << UserRole.create(:role_id => Role.find_by_name(name).id)
  end
  
  def availability_status
    if (last_request_at.nil? || (last_request_at < Time.now - MAX_IDLE))
      if available == 'online'
        update_attribute(:available, 'busy') 
        return 'busy'
      end
    else
      available
    end
  end
  
  def is_online?
    # check_for_last_request - 
    # if less than 3 minutes ago 
    # check for online_status
    # if more than 3 minutes
    # send js via faye to client
  end
  
  def available?
    #TODO out for testing
    availability_status == 'online' ? true : false
  end
  
  def set_online!
    update_attribute(:available, 'online')
  end
  
  def set_offline!
    update_attribute(:available, 'offline')
  end
  
  def set_busy!
    update_attribute(:available, 'busy')
  end
  
  def message_queue
    Message.where("receiver_id = ? AND receiver_deleted = ? OR sender_id = ? AND sender_deleted = ?", self.id, false, self.id, false).order('created_at DESC')
  end
  
  def conversations
    Conversation.where("user_1_id=? OR user_2_id=?", self.id, self.id).order("created_at DESC")
  end
  
  # devise authentication hook
  #
  def after_database_authentication
    logger.debug("User#after_database_authentication - setting online")
    set_online!
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
  
  def self.cleanup_online_states
    ret = []
    ret.push User.where(" (available = ? OR available = ?) AND last_request_at < ?", 'online', 'busy', SET_OFFLINE.ago ).each { |u| u.update_attribute(:available, 'offline') }.count
    ret.push User.where("available = ? AND last_request_at < ?", 'online', SET_BUSY.ago ).each { |u| u.update_attribute(:available, 'busy') }.count
    ret
  end
  
  def self.potentially_available
    User.where("( available = ? OR available = ? ) AND last_request_at > ? ", 'busy','online', MAX_IDLE.ago )
  end
  
  def self.online_status_for_ids(ids)
    Rails.logger.debug("User#online_status_for_ids - ids: #{ids}")
    User.where("id IN (?)", ids).select([:id,:available])
  end
  
  # FIXME status is always 200 - 
  # we need a different way to check if user is online
  #
  def check_with_push
    ret = PrivatePub.publish_to("/notifications/#{self.id}", 'check')
    Rails.logger.debug("User#check_with_push - #{ret}")
  end
 
  private
 
  def add_default_user_role
    user_roles << UserRole.create({:role_id => Role.find_by_name('user').id})
  end
  
  def add_account
    Rails.logger.debug("User#add_account - locale: #{I18n.locale}")
    self.create_account(:language_1 => I18n.locale.upcase, :timezone => "Berlin" )
  end
  
  def set_default_online_status
    update_attribute(:available, 'online')
  end
  
  def set_offline_status
    update_attribute(:available, 'offline')
  end
end
