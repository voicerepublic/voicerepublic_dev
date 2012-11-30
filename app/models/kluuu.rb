class Kluuu < Klu
  attr_accessible :klu_images_attributes
  
  CHARGE_TYPES = %w{free minute fix}
  
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  has_many :klu_images, :foreign_key => :klu_id, :dependent => :destroy
  # because of STI in Klu - rateable_type will always be 'Klu'
  has_many :ratings, :as => :rateable, :dependent => :destroy 
  
  # see base-class for base-validations
  validates_presence_of :charge_cents, :description, :category_id #, :currency  #, :currency
  validate :set_currency, :if => Proc.new { |k| k.charge_type != 'free' }
  validate :check_charge
  
  accepts_nested_attributes_for :klu_images, :allow_destroy => true
  
  monetize :charge_cents
  
  after_create :generate_notification  # defined in base-class
  
  def set_currency
    unless self.user.balance_account.nil?
      self.currency = self.user.balance_account.currency
    else
      self.errors.add(:currency, I18n.t('.no_account', :default => 'You got to create an balance account before You can charge for your KluuUs'))
    end
  end
  
  def check_charge
    if charge_type == 'minute'
      unless charge_cents < 501 || charge_cents > 9
        self.errors.add(:charge_cents, I18n.t('.charge_per_minute_error', :default => "Minimum 10 and maximum 500"))
      end
    end
    if charge_type == 'fix'
      unless charge_cents < 5001 || charge_cents > 99
        self.errors.add(:charge_cents, I18n.t('.charge_fixed_error', :default => "Minimum 100 and maximum 5000"))
      end
    end
    if charge_type == 'free'
      if charge_cents > 0 || charge_cents < 0
        self.errors.add(:charge_cents, I18n.t('.charge_free_error', :default => "You should leave the amount at zero if this is a free kluuu"))
      end
    end
  end
    
end
