class Kluuu < Klu
  
  
  CHARGE_TYPES = %w{free minute fix}
  
  has_many :bookmarks, :dependent => :destroy, :foreign_key => :klu_id
  has_many :klu_images, :foreign_key => :klu_id, :dependent => :destroy
  
  accepts_nested_attributes_for :klu_images
  
  # see base-class for base-validations
  validates_presence_of :currency, :charge_amount, :description, :category_id
  
  composed_of :charge,
              :class_name => "Money",
              :mapping => [%w(charge_amount cents), %w(currency currency_as_string)],
              :constructor => Proc.new { |cents , currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
  
end
