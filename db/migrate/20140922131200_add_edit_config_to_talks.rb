class AddEditConfigToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :edit_config, :text
  end
end
