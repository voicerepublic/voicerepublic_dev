class AddEditConfigToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :edit_config, :text
  end
end
