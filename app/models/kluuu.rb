class Kluuu < Klu
  
  
  CHARGE_TYPES = %w{free minute fix}
  
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  has_many :klu_images, :foreign_key => :klu_id, :dependent => :destroy
  # because of STI in Klu - rateable_type will always be 'Klu'
  has_many :ratings, :as => :rateable, :dependent => :destroy 
  
  # see base-class for base-validations
  validates_presence_of :charge_amount, :description, :category_id #, :currency  #, :currency
  
  accepts_nested_attributes_for :klu_images, :allow_destroy => true
  
  composed_of :charge,
              :class_name => "Money",
              :mapping => [%w(charge_amount cents), %w(currency currency_as_string)],
              :constructor => Proc.new { |cents , currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  after_create :generate_notification  # defined in base-class
    
end
