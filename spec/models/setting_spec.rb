require 'rails_helper'

describe Setting do

  describe 'on class level' do
    it 'has a scope get which returns the value' do
      setting = FactoryGirl.create(:setting)
      found = Setting.get(setting.key)
      expect(found).to eq(setting.value)
    end

    it 'falls back to settings provided by rails_config' do
      found = Setting.get('rtmp.build_path')
      expect(found).to eq(Settings.rtmp.build_path)
    end
  end
  
end
