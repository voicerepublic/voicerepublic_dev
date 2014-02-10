class AddTeaserAndDescriptionToTalk < ActiveRecord::Migration
  def change
    add_column :talks, :teaser, :string
    add_column :talks, :description, :text
  end
end
