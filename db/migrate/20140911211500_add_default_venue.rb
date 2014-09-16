class AddDefaultVenue < ActiveRecord::Migration
  def change
    add_column :venues, :default, :boolean, default: false

    User.all.each { |user|
      Venue.new( { :default     => true,
                   :user        => user,
                   :title       => "My Talks",
                   :teaser      => "various talks",
                   :description => "Various talks, that don't belong to any particular series",
                   :tag_list    => "default"
                 } ).save
    }
  end
end
