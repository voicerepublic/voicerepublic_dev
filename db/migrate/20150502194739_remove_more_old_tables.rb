class RemoveMoreOldTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :articles                        if exists? :articles
    drop_table :balance_accounts                if exists? :balance_accounts
    drop_table :balance_check_in_orders         if exists? :balance_check_in_orders
    drop_table :categories                      if exists? :categories
    drop_table :category_translations           if exists? :category_translations
    drop_table :conversations                   if exists? :conversations
    drop_table :credit_accounts                 if exists? :credit_accounts
    drop_table :events                          if exists? :events
    drop_table :kblog_articles                  if exists? :kblog_articles
    drop_table :klu_images                      if exists? :klu_images
    drop_table :klus                            if exists? :klus
    drop_table :notification_bases              if exists? :notification_bases
    drop_table :participant_bases               if exists? :participant_bases
    drop_table :paypal_payments                 if exists? :paypal_payments
    drop_table :ratings                         if exists? :ratings
    drop_table :refinery_images                 if exists? :refinery_images
    drop_table :refinery_page_part_translations if exists? :refinery_page_part_translations
    drop_table :refinery_page_parts             if exists? :refinery_page_parts
    drop_table :refinery_page_translations      if exists? :refinery_page_translations
    drop_table :refinery_pages                  if exists? :refinery_pages
    drop_table :refinery_resources              if exists? :refinery_resources
    drop_table :refinery_roles                  if exists? :refinery_roles
    drop_table :refinery_roles_users            if exists? :refinery_roles_users
    drop_table :refinery_user_plugins           if exists? :refinery_user_plugins
    drop_table :refinery_users                  if exists? :refinery_users
    drop_table :seo_meta                        if exists? :seo_meta
    drop_table :transfers                       if exists? :transfers
    drop_table :venue_klus                      if exists? :venue_klus
    drop_table :video_rooms                     if exists? :video_rooms
    drop_table :video_servers                   if exists? :video_servers
    drop_table :video_session_bases             if exists? :video_session_bases
  end

  def exists?(table)
    ActiveRecord::Base.connection.table_exists? table
  end
end
