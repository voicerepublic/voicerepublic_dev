class AddStateToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :state, :string
  end
end
