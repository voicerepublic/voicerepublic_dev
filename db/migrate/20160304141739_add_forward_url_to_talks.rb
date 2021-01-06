class AddForwardUrlToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :forward_url, :string
  end
end
