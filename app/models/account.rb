require 'kluuu_code'

# Attributes:
# * id [integer, primary, not null] - primary key
# * about [text] - TODO: document me
# * created_at [datetime, not null] - creation time
# * language_1 [string] - TODO: document me
# * language_2 [string] - TODO: document me
# * language_3 [string] - TODO: document me
# * portrait_content_type [string] - Paperclip for portrait
# * portrait_file_name [string] - Paperclip for portrait
# * portrait_file_size [integer] - Paperclip for portrait
# * portrait_updated_at [datetime] - Paperclip for portrait
# * prefs [text] - TODO: document me
# * timezone [string] - TODO: document me
# * updated_at [datetime, not null] - last update time
# * user_id [integer] - belongs to :user
# * website [string] - TODO: document me

class Account < ActiveRecord::Base
  include KluuuCode::Methods

  attr_accessible :language_1, :language_2, :language_3,
                  :timezone, :user_id, :about, :portrait,
                  :prefs, :website

  # FIXME: for migration of old kluuu
  attr_accessible :portrait_file_name, :portrait_content_type,
                  :portrait_file_size
  
  serialize :prefs, KluuuCode::Preferences

  has_attached_file :portrait, :styles => {
    :large => "360x360#",
    :medium => "180x180#",
    :thumb => "45x45#" 
  }, :default_url => "/system/:style/missing.png"

  belongs_to :user

  validates :user_id, :language_1, :timezone, :presence => true

  # https://github.com/grosser/i18n_data
  # languages: I18nData.languages(:en) # {'DE' => 'Deutschland',...}
  # translates e.g. attribute :language_1 with value 'DE' to 'German' or 'Deutsch'
  # according to supplied locale
  #
  def language_name(num=1, locale=I18n.locale)
    begin
      _short = self.send("language_#{num}")
      unless _short.nil?
        return I18nData.languages(locale)[self.send("language_#{num}")]
      end
      return nil
    rescue I18nData::NoTranslationAvailable
      self.send("language_#{num}")
    rescue  NoMethodError
      nil
    end
  end
  
  def languages(locale=I18n.locale)
    arr = []
    [1,2,3].each do |i|
      if self.send("language_#{i}") && self.send("language_#{i}").length > 1
        arr.push( I18nData.languages(locale)[self.send("language_#{i}")] ) 
      end
    end
    arr
  end

  def time_in_supplied_zone(arg=Time.now)
    Time.zone = self.timezone
    arg.in_time_zone
  end
  
  def preferred_locale
    [1,2].each do |i|
      # TODO available translations should be configured in a central place instead
      # of clutterin them throughout the code...
      #
      if %w{ DE EN }.include?( self.send("language_#{i}") )
        return self.send("language_#{i}").downcase 
      end
    end
    "en" # return english as default if user has not configured available langs
  end
  
  def website_as_url
    website =~ /\Ahttps?:/ ? website : "http://#{website}"
  end
  
  def website_as_name
    website =~ /\Ahttps?:/ ? website.gsub(%r/\Ahttps?:\/\//,"") : website
  end

end
