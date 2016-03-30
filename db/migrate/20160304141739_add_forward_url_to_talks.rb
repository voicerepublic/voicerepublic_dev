class AddForwardUrlToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :forward_url, :string
  end
end
