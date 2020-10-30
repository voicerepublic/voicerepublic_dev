class AddDurationToTalk < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :duration, :integer
  end
end
