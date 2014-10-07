class AddSummaryToUsers < ActiveRecord::Migration
  def change
    add_column :users, :summary, :string
  end
end
