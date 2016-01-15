class AddIconToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :icon, :string, default: 'default'
  end
end
