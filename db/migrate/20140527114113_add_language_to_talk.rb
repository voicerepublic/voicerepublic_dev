class AddLanguageToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :language, :string, default: 'en'
  end
end
