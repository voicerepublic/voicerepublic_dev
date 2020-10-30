class AddStateToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :state, :string
  end
end
