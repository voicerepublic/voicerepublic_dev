class AddPopularityAndPenaltyToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :popularity, :float, default: 1
    add_column :talks, :penalty, :float, default: 1

    add_index :talks, :popularity
  end
end
