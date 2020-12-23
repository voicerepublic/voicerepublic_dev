class ChangeDefaultValueAboutForUsers < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :about, :text, default: ''
  end
end
