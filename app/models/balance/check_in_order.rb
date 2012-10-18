class Balance::CheckInOrder < ActiveRecord::Base
  attr_accessible :amount_cents, :completed, :completed_at, :balance_account_id, :currency
  attr_accessible :amount  # used by rails_money-gem uses amount_cents as base
  
  belongs_to :balance_account, :class_name => 'Balance::Account'

  monetize :amount_cents

  before_create :set_currency
  
  validates :currency, :presence => true
  validates :amount_cents, :numericality => { :greater_than => 0 }
  validates :balance_account_id, :presence => true
  
  PAYMENT_VALUES = {"10" => 10.00, "20" => 20.00, "30" => 30.00, "50" => 50.00, "100" => 100.00}
  CERTS = File.join(Rails.root, "config", "certs_#{Rails.env}")
  PAYPALCONFIG = YAML.load_file(File.join(Rails.root,'config','paypal_config.yml'))[Rails.env.to_sym]

  # simple arguments hash to be used in formfields - or url-params
  #
  def plain_paypal(return_url, notify_url)
    {
      :business => paypal_config_for(:email),
      :cmd => "_xclick",
      :item_name => "KluuUs",
      :amount => self.amount.dollars,    # dollars here sounds weired but - its just maths: (amount.to_f / 100).round(2)
      :currency_code => self.currency,
      :invoice => self.id,
      :return => return_url,
      :notify_url => notify_url.split("?")[0] << "?secret=#{PAYPALCONFIG[:secret]}", #split foo wegen locale
      :cert_id => PAYPALCONFIG[:cert_id]
      #TODO :cancel_return => pfad nach destroy checkinorder
    }
  end
  
  # encrypted version von arguments to be used in posts to paypal
  #
  def encrypted_paypal(return_url, notify_url)
    encrypt_for_paypal(plain_paypal(return_url, notify_url))
  end
  
  # url to the paypal-api - without any arguments
  #
  def paypal_base_url
    Balance::CheckInOrder::PAYPALCONFIG[:paypal_base_url] 
  end


  private
  
  def set_currency
    self.currency = self.balance_account.currency
  end
  
  
  def paypal_config_for(key)
    pp_conf = Balance::CheckInOrder::PAYPALCONFIG
    raise unless pp_conf[:kluuu_account].has_key?(key)
    pp_conf[:kluuu_account][key]
  end
  
  def app_cert
    File.read(File.join(CERTS, PAYPALCONFIG[:app_cert]))
  end
  
  def app_key
    File.read(File.join(CERTS, PAYPALCONFIG[:app_key]))
  end
  
  def paypal_cert
    File.read(File.join(CERTS, PAYPALCONFIG[:paypal_cert]))
  end
  
  # encrypted for paypal and signed with our app_cert
  #
  def encrypt_for_paypal(values)
    signed = OpenSSL::PKCS7::sign(OpenSSL::X509::Certificate.new(app_cert), OpenSSL::PKey::RSA.new(app_key, ''), values.map { |k, v| "#{k}=#{v}" }.join("\n"), [], OpenSSL::PKCS7::BINARY)
    OpenSSL::PKCS7::encrypt([OpenSSL::X509::Certificate.new(paypal_cert)], signed.to_der, OpenSSL::Cipher::Cipher::new("DES3"), OpenSSL::PKCS7::BINARY).to_s.gsub("\n", "")
  end


end

