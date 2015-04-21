class AddSocialLinksToTalks < ActiveRecord::Migration
  def change
    add_column :talks, :social_links, :text, default: "--- []"
  end
end
