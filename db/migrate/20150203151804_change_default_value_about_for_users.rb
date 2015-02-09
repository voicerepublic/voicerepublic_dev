class ChangeDefaultValueAboutForUsers < ActiveRecord::Migration
  def change
    change_column :users, :about, :text, default: ''
  end
end
