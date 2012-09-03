class ProfileSetting < ActiveRecord::Base
  attr_accessible :language_1, :language_2, :language_3, :timezone, :user_id, :about
  
  belongs_to :user
  
  # https://github.com/grosser/i18n_data
  # languages: I18nData.languages(:en) # {'DE' => 'Deutschland',...}
  
end
