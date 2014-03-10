# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140309111121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "accounts", force: true do |t|
    t.string   "timezone"
    t.string   "language_1"
    t.string   "language_2"
    t.string   "language_3"
    t.integer  "user_id"
    t.text     "about"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "portrait_file_name"
    t.string   "portrait_content_type"
    t.integer  "portrait_file_size"
    t.datetime "portrait_updated_at"
    t.text     "prefs"
    t.string   "website"
  end

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "appearances", force: true do |t|
    t.integer  "user_id"
    t.integer  "talk_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appearances", ["talk_id"], name: "index_appearances_on_talk_id", using: :btree
  add_index "appearances", ["user_id"], name: "index_appearances_on_user_id", using: :btree

  create_table "articles", force: true do |t|
    t.integer  "venue_id"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  add_index "articles", ["deleted_at"], name: "index_articles_on_deleted_at", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree
  add_index "articles", ["venue_id"], name: "index_articles_on_venue_id", using: :btree

  create_table "balance_accounts", force: true do |t|
    t.string   "currency"
    t.integer  "balance_cents", default: 0
    t.integer  "revenue_cents", default: 0
    t.integer  "user_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "balance_check_in_orders", force: true do |t|
    t.integer  "balance_account_id"
    t.boolean  "completed"
    t.datetime "completed_at"
    t.string   "currency"
    t.integer  "amount_cents"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "bookmarks", force: true do |t|
    t.integer  "klu_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "category_translations", force: true do |t|
    t.integer  "category_id"
    t.string   "locale"
    t.string   "name"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "article_id",       null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: true do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.integer  "offset_1"
    t.integer  "offset_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "conversations", ["user_1_id"], name: "index_conversations_on_user_1_id", using: :btree
  add_index "conversations", ["user_2_id"], name: "index_conversations_on_user_2_id", using: :btree

  create_table "credit_accounts", force: true do |t|
    t.integer  "user_id"
    t.integer  "prepaid_amount"
    t.integer  "revenue_amount"
    t.string   "currency"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: true do |t|
    t.datetime "start_time"
    t.integer  "duration"
    t.integer  "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "record"
    t.string   "title",      null: false
    t.string   "recording"
    t.datetime "end_at"
  end

  add_index "events", ["start_time"], name: "index_events_on_start_time", using: :btree
  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "follows", force: true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "kblog_articles", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "klu_images", force: true do |t|
    t.text     "description"
    t.integer  "klu_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "klus", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.string   "available_at_times"
    t.integer  "user_id"
    t.boolean  "published",          default: false
    t.integer  "category_id"
    t.string   "type"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "charge_type",        default: "free"
    t.string   "currency"
    t.integer  "charge_cents",       default: 0
  end

  add_index "klus", ["charge_type"], name: "index_klus_on_charge_type", using: :btree

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "talk_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["talk_id"], name: "index_messages_on_talk_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "notification_bases", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "klu_id"
    t.integer  "other_id"
    t.string   "url"
    t.string   "type"
    t.boolean  "read",             default: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "video_session_id"
    t.string   "anon_id"
  end

  add_index "notification_bases", ["user_id"], name: "index_notification_bases_on_user_id", using: :btree

  create_table "participant_bases", force: true do |t|
    t.string   "type"
    t.integer  "video_session_id"
    t.datetime "entered_timestamp"
    t.datetime "left_timestamp"
    t.string   "room_url"
    t.string   "video_session_role"
    t.string   "user_cookie_session_id"
    t.integer  "user_id"
    t.integer  "seconds_online",            default: 0
    t.datetime "last_pay_tick_timestamp"
    t.integer  "pay_tick_counter",          default: 0
    t.datetime "payment_started_timestamp"
    t.datetime "payment_stopped_timestamp"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "participations", force: true do |t|
    t.integer  "venue_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree
  add_index "participations", ["venue_id"], name: "index_participations_on_venue_id", using: :btree

  create_table "paypal_payments", force: true do |t|
    t.text     "params"
    t.integer  "check_in_order_id"
    t.string   "status"
    t.integer  "amount_cents"
    t.string   "tact_id"
    t.string   "currency"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pg_search_documents", ["content"], name: "index_pg_search_documents_on_content", using: :btree

  create_table "ratings", force: true do |t|
    t.integer  "rateable_id"
    t.integer  "user_id"
    t.string   "rateable_type"
    t.text     "content"
    t.integer  "score",         default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "ratings", ["rateable_id"], name: "index_ratings_on_rateable_id", using: :btree
  add_index "ratings", ["rateable_type"], name: "index_ratings_on_rateable_type", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "refinery_images", force: true do |t|
    t.string   "image_mime_type"
    t.string   "image_name"
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_uid"
    t.string   "image_ext"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "refinery_page_part_translations", force: true do |t|
    t.integer  "refinery_page_part_id"
    t.string   "locale"
    t.text     "body"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "refinery_page_part_translations", ["locale"], name: "index_refinery_page_part_translations_on_locale", using: :btree
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], name: "index_f9716c4215584edbca2557e32706a5ae084a15ef", using: :btree

  create_table "refinery_page_parts", force: true do |t|
    t.integer  "refinery_page_id"
    t.string   "title"
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "refinery_page_parts", ["id"], name: "index_refinery_page_parts_on_id", using: :btree
  add_index "refinery_page_parts", ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id", using: :btree

  create_table "refinery_page_translations", force: true do |t|
    t.integer  "refinery_page_id"
    t.string   "locale"
    t.string   "title"
    t.string   "custom_slug"
    t.string   "menu_title"
    t.string   "slug"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "refinery_page_translations", ["locale"], name: "index_refinery_page_translations_on_locale", using: :btree
  add_index "refinery_page_translations", ["refinery_page_id"], name: "index_d079468f88bff1c6ea81573a0d019ba8bf5c2902", using: :btree

  create_table "refinery_pages", force: true do |t|
    t.integer  "parent_id"
    t.string   "path"
    t.string   "slug"
    t.boolean  "show_in_menu",        default: true
    t.string   "link_url"
    t.string   "menu_match"
    t.boolean  "deletable",           default: true
    t.boolean  "draft",               default: false
    t.boolean  "skip_to_first_child", default: false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "view_template"
    t.string   "layout_template"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "refinery_pages", ["depth"], name: "index_refinery_pages_on_depth", using: :btree
  add_index "refinery_pages", ["id"], name: "index_refinery_pages_on_id", using: :btree
  add_index "refinery_pages", ["lft"], name: "index_refinery_pages_on_lft", using: :btree
  add_index "refinery_pages", ["parent_id"], name: "index_refinery_pages_on_parent_id", using: :btree
  add_index "refinery_pages", ["rgt"], name: "index_refinery_pages_on_rgt", using: :btree

  create_table "refinery_resources", force: true do |t|
    t.string   "file_mime_type"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_uid"
    t.string   "file_ext"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "refinery_roles", force: true do |t|
    t.string "title"
  end

  create_table "refinery_roles_users", id: false, force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "refinery_roles_users", ["role_id", "user_id"], name: "index_refinery_roles_users_on_role_id_and_user_id", using: :btree
  add_index "refinery_roles_users", ["user_id", "role_id"], name: "index_refinery_roles_users_on_user_id_and_role_id", using: :btree

  create_table "refinery_user_plugins", force: true do |t|
    t.integer "user_id"
    t.string  "name"
    t.integer "position"
  end

  add_index "refinery_user_plugins", ["name"], name: "index_refinery_user_plugins_on_name", using: :btree
  add_index "refinery_user_plugins", ["user_id", "name"], name: "index_refinery_user_plugins_on_user_id_and_name", unique: true, using: :btree

  create_table "refinery_users", force: true do |t|
    t.string   "username",               null: false
    t.string   "email",                  null: false
    t.string   "encrypted_password",     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.datetime "remember_created_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "refinery_users", ["id"], name: "index_refinery_users_on_id", using: :btree

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "seo_meta", force: true do |t|
    t.integer  "seo_meta_id"
    t.string   "seo_meta_type"
    t.string   "browser_title"
    t.string   "meta_keywords"
    t.text     "meta_description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "seo_meta", ["id"], name: "index_seo_meta_on_id", using: :btree
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], name: "index_seo_meta_on_seo_meta_id_and_seo_meta_type", using: :btree

  create_table "social_shares", force: true do |t|
    t.integer  "shareable_id"
    t.string   "shareable_type"
    t.string   "request_ip"
    t.string   "user_agent"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "social_network"
  end

  add_index "social_shares", ["shareable_id", "shareable_type"], name: "index_social_shares_on_shareable_id_and_shareable_type", using: :btree

  create_table "status_updates", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  create_table "talks", force: true do |t|
    t.string   "title"
    t.integer  "venue_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "ended_at"
    t.boolean  "record"
    t.string   "recording"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
    t.text     "description"
    t.integer  "duration"
    t.string   "image_uid"
    t.text     "session"
    t.text     "audio_formats", default: "--- []\n"
    t.datetime "featured_from"
    t.string   "state"
    t.datetime "started_at"
    t.datetime "processed_at"
  end

  create_table "transfers", force: true do |t|
    t.integer  "account_id"
    t.integer  "video_session_id"
    t.integer  "duration"
    t.integer  "transfer_charge_cents"
    t.string   "transfer_charge_currency"
    t.integer  "transfer_gross_cents"
    t.string   "transfer_gross_currency"
    t.integer  "video_session_charge_cents"
    t.string   "video_session_charge_currency"
    t.decimal  "exchange_rate",                 precision: 10, scale: 5
    t.string   "video_session_klu_name"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  create_table "user_roles", force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "users", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.text     "slug"
    t.datetime "last_request_at"
    t.string   "available"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.boolean  "guest"
    t.string   "header_uid"
    t.string   "avatar_uid"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "venue_klus", force: true do |t|
    t.integer  "venue_id"
    t.integer  "klu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "venue_klus", ["venue_id"], name: "index_venue_klus_on_venue_id", using: :btree

  create_table "venues", force: true do |t|
    t.datetime "start_time"
    t.text     "description"
    t.string   "title"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "duration"
    t.text     "teaser"
    t.datetime "featured_from"
    t.integer  "user_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.text     "options",            default: "--- {}\n"
  end

  add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree

  create_table "video_rooms", force: true do |t|
    t.integer  "video_server_id"
    t.integer  "video_session_id"
    t.integer  "participant_count"
    t.string   "video_system_room_id"
    t.string   "name"
    t.string   "guest_password"
    t.string   "host_password"
    t.string   "welcome_msg"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "video_rooms", ["video_system_room_id"], name: "index_video_rooms_on_video_system_room_id", unique: true, using: :btree

  create_table "video_servers", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "salt"
    t.boolean  "activated"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "video_session_bases", force: true do |t|
    t.datetime "end_timestamp"
    t.datetime "begin_timestamp"
    t.string   "video_system_session_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "klu_id"
    t.string   "type"
  end

end
