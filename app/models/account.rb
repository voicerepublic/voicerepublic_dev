require 'kluuu_code'

class Account < ActiveRecord::Base
  include KluuuCode::Methods
  
  attr_accessible :language_1, :language_2, :language_3, :timezone, :user_id, :about, :portrait, :prefs
  serialize :prefs, KluuuCode::Preferences
  
  has_attached_file :portrait, :styles => { :large => "360x360#", :medium => "180x180#", :thumb => "90x90#" }, :default_url => "/system/:style/missing.jpg"
  
  belongs_to :user
  
  validates :user_id, :presence => true
  validates :language_1, :presence => true
  validates :timezone, :presence => true
  
  
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
      arr.push( I18nData.languages(locale)[self.send("language_#{i}")] ) if self.send("language_#{i}") && self.send("language_#{i}").length > 1
    end
    arr
  end
  
  def time_in_supplied_zone(arg=Time.now)
    Time.zone = self.timezone
    arg.in_time_zone
  end
  
  
end
