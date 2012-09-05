class ProfileSetting < ActiveRecord::Base
  attr_accessible :language_1, :language_2, :language_3, :timezone, :user_id, :about, :portrait
  
  belongs_to :user
  
  has_attached_file :portrait, :styles => { :large => "300x300>", :medium => "150x150>", :thumb => "50x50>" }
  
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
  
  def time_in_supplied_zone(arg=Time.now)
    Time.zone = self.timezone
    arg.in_time_zone
  end
  
end
