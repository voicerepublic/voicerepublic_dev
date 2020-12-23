class AddIconToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :icon, :string, default: 'default'
  end
end
