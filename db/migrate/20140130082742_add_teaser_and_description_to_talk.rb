class AddTeaserAndDescriptionToTalk < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :teaser, :string
    add_column :talks, :description, :text
  end
end
