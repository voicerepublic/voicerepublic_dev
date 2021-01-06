class AddSummaryToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :summary, :string
  end
end
