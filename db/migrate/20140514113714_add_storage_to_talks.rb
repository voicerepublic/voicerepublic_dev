class AddStorageToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :storage, :text
  end
end
