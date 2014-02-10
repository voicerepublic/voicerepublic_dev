class AddSessionToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :session, :text
  end
end
