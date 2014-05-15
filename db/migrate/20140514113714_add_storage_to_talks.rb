class AddStorageToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :storage, :text
  end
end
