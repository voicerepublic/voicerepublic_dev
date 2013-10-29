class Transfer < ActiveRecord::Base
  
  belongs_to :account, :class_name => 'Balance::Account'
  belongs_to :video_session, :class_name => 'VideoSession'
  
  attr_accessible :account_id, :duration, :exchange_rate, :transfer_gross, :transfer_charge, :video_session_charge, :transfer_charge_cents, :transfer_charge_currency, :transfer_gross_cents, :transfer_gross_currency, :video_session_charge_cents, :video_session_charge_currency, :video_session_id, :video_session_klu_name
  
  validates_presence_of :video_session_id, :video_session_charge_cents, :transfer_charge_cents, :transfer_gross_cents, :duration, :transfer_charge_currency, :transfer_gross_currency, :video_session_charge_currency, :exchange_rate, :video_session_klu_name
  
  composed_of :video_session_charge,
              :class_name => "Money",
              :mapping => [%w(video_session_charge_cents cents), %w(video_session_charge_currency currency_as_string)],
              :constructor => Proc.new { |cents , currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }
  
  composed_of :transfer_charge,
              :class_name => "Money",
              :mapping => [%w(transfer_charge_cents cents), %w(transfer_charge_currency currency_as_string)],
              :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  composed_of :transfer_gross,
              :class_name => "Money",
              :mapping => [%w(transfer_gross_cents cents), %w(transfer_gross_currency currency_as_string)],
              :constructor => Proc.new { |cents, currency| Money.new(cents || 0, currency) },
              :converter => Proc.new { |value| value.respond_to?(:to_money) ? value.to_money : raise(ArgumentError, "Can't convert #{value.class} to Money") }

  
  scope :incoming, where("transfer_charge_cents >?",0)
  scope :outgoing, where("transfer_charge_cents <?",0)
  
  # provides the brutto sum of this transfer
  def brutto
    return self.transfer_gross
  end
  
  # provides the netto sum of this transfer
  def netto
    return self.transfer_charge
  end
  
  # provides the kluuu charge of this transfer
  # only calculate in case of incoming transfer
  def kluuu_charge
    if ((netto <=> Money.new(0, self.transfer_charge_currency)) > 0)
      kluuu_charge = brutto - netto
      return kluuu_charge
    end
  end

end
