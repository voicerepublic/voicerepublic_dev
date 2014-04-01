class AddDurationToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :duration, :integer
  end
end
