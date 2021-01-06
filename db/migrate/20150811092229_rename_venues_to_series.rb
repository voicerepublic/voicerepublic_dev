class RenameVenuesToSeries < ActiveRecord::Migration[6.0]
  def change

    # TABLE
    rename_table :venues, :series

    # COLUMNS
    rename_column :participations, :venue_id, :series_id
    rename_column :talks, :venue_id, :series_id
    rename_column :users, :default_venue_id, :default_series_id

    # INDICES (TODO!)

    # POLYMORPHICS
    poly = {
      reminders: :rememberable_type,
      social_shares: :shareable_type,
      taggings: :taggable_type,
      comments: :commentable_type,
      pg_search_documents: :searchable_type,
      active_admin_comments: :resource_type
    }

    poly.each do |table, column|
      execute "UPDATE #{table} SET #{column}='Series' WHERE #{column}='Venue'"
    end

  end
end
