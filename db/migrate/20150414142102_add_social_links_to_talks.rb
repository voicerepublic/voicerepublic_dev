class AddSocialLinksToTalks < ActiveRecord::Migration[6.0]
  def change
    add_column :talks, :social_links, :text, default: "--- []"
  end
end
