class AddSessionToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :session, :text
  end
end
