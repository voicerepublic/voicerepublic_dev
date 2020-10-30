class AddPopularityAndPenaltyToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :popularity, :float, default: 1
    add_column :talks, :penalty, :float, default: 1

    add_index :talks, :popularity
  end
end
