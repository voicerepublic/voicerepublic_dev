class RemoveMoreOldTables < ActiveRecord::Migration
  def change
    drop_table :articles
    drop_table :balance_accounts
    drop_table :balance_check_in_orders
    drop_table :categories
    drop_table :category_translations
    drop_table :conversations
    drop_table :credit_accounts
    drop_table :events
    drop_table :kblog_articles
    drop_table :klu_images
    drop_table :klus
    drop_table :notification_bases
    drop_table :participant_bases
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
    drop_table :seo_meta
    drop_table :transfers
    drop_table :venue_klus
    drop_table :video_rooms
    drop_table :video_servers
    drop_table :video_session_bases
  end
end
