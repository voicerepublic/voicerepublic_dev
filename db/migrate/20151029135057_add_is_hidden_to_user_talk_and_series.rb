class AddIsHiddenToUserTalkAndSeries < ActiveRecord::Migration
  def change
    add_column :users, :is_hidden, :boolean, default: false
    add_column :talks, :is_hidden, :boolean, default: false
    add_column :series, :is_hidden, :boolean, default: false
  end
end
