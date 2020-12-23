class Housecleaning < ActiveRecord::Migration[6.0]

  def change

    execute "UPDATE talks SET recording = REPLACE(recording, '.m4a', '');"

    execute <<-EOF
      INSERT INTO talks (title, starts_at, duration, teaser,
      description, record, venue_id, updated_at, created_at,
      recording, ended_at) SELECT title, start_time, duration, title,
      title, record, venue_id, updated_at, created_at, recording,
      end_at FROM events;
    EOF

    # simulate callback
    execute "UPDATE talks SET ends_at = starts_at + duration * interval '1 minute';"

    execute <<-EOF
      UPDATE talks SET state = 'postlive' WHERE ends_at < NOW();
      UPDATE talks SET state = 'prelive' WHERE starts_at > NOW();
      UPDATE talks SET state = 'live' WHERE state IS NULL;
    EOF

    drop_table :balance_accounts
    drop_table :balance_check_in_orders
    drop_table :bookmarks
    drop_table :categories
    drop_table :category_translations
    drop_table :conversations
    drop_table :credit_accounts
    drop_table :events
    # drop_table :follows
    drop_table :kblog_articles
    drop_table :klu_images
    drop_table :klus
    drop_table :messages
    drop_table :participant_bases
    drop_table :notification_bases
    drop_table :paypal_payments
    drop_table :ratings
    drop_table :refinery_images
    drop_table :refinery_page_part_translations
    drop_table :refinery_page_parts
    drop_table :refinery_page_translations
    drop_table :refinery_pages
    drop_table :refinery_resources
    drop_table :refinery_roles
    drop_table :refinery_roles_users
    drop_table :refinery_user_plugins
    drop_table :refinery_users
    drop_table :roles
    drop_table :seo_meta
    drop_table :status_updates
    drop_table :transfers
    drop_table :user_roles
    drop_table :venue_klus
    drop_table :video_rooms
    drop_table :video_servers
    drop_table :video_session_bases
  end
  
  private

  def drop_table(table)
    super if ActiveRecord::Base.connection.table_exists?(table)
  end

end
