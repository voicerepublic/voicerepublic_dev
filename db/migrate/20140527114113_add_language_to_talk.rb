class AddLanguageToTalk < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :language, :string, default: 'en'
  end
end
