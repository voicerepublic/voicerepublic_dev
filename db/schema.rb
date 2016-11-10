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

ActiveRecord::Schema.define(version: 20160912142726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: :cascade do |t|
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

  create_table "admin_users", force: :cascade do |t|
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

  create_table "appearances", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "talk_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appearances", ["talk_id"], name: "index_appearances_on_talk_id", using: :btree
  add_index "appearances", ["user_id"], name: "index_appearances_on_user_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
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

  create_table "device_reports", force: :cascade do |t|
    t.integer  "device_id"
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "device_reports", ["device_id"], name: "index_device_reports_on_device_id", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string   "identifier"
    t.string   "type"
    t.string   "subtype"
    t.string   "name"
    t.string   "state"
    t.datetime "last_heartbeat_at"
    t.integer  "organization_id"
    t.datetime "paired_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.datetime "disappeared_at"
    t.string   "target",               default: "live"
    t.string   "public_ip_address"
    t.integer  "loglevel",             default: 1
    t.integer  "report_interval",      default: 60
    t.integer  "heartbeat_interval",   default: 5
    t.text     "options",              default: "--- {}"
    t.string   "pairing_code"
    t.string   "source_branch",        default: "master"
    t.string   "capture_device",       default: "dsnooped"
    t.string   "private_ip_address"
    t.string   "mac_address_ethernet"
    t.string   "version"
    t.string   "mac_address_wifi"
  end

  add_index "devices", ["organization_id"], name: "index_devices_on_organization_id", using: :btree
  add_index "devices", ["pairing_code"], name: "index_devices_on_pairing_code", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "organization_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "memberships", ["organization_id"], name: "index_memberships_on_organization_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "talk_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["talk_id"], name: "index_messages_on_talk_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "metrics", force: :cascade do |t|
    t.string   "key"
    t.float    "value"
    t.datetime "created_at"
  end

  add_index "metrics", ["created_at"], name: "index_metrics_on_created_at", using: :btree
  add_index "metrics", ["key"], name: "index_metrics_on_key", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "credits"
    t.string   "image_uid"
    t.string   "image_name"
    t.string   "image_alt"
    t.string   "logo_uid"
    t.string   "logo_name"
    t.string   "logo_alt"
    t.text     "description"
    t.text     "description_as_html"
    t.text     "description_as_text"
    t.string   "website"
    t.float    "penalty"
    t.boolean  "paying"
    t.datetime "featured_from"
    t.datetime "featured_until"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "series_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "participations", ["series_id"], name: "index_participations_on_series_id", using: :btree
  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pg_search_documents", ["content"], name: "index_pg_search_documents_on_content", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "quantity",         default: 1
    t.integer  "amount"
    t.datetime "purchased_at"
    t.string   "ip"
    t.string   "express_token"
    t.string   "express_payer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "details"
    t.integer  "owner_id"
    t.string   "product"
    t.decimal  "total"
    t.string   "country"
  end

  create_table "reminders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rememberable_id"
    t.string   "rememberable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["rememberable_type", "rememberable_id"], name: "index_reminders_on_rememberable_type_and_rememberable_id", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "sections", force: :cascade do |t|
    t.string   "locale"
    t.string   "key"
    t.text     "content"
    t.text     "content_as_html", default: ""
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "sections", ["key"], name: "index_sections_on_key", using: :btree
  add_index "sections", ["locale"], name: "index_sections_on_locale", using: :btree

  create_table "series", force: :cascade do |t|
    t.text     "description"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
    t.integer  "user_id"
    t.text     "options",             default: "--- {}\n"
    t.string   "image_uid"
    t.string   "uri"
    t.string   "slug"
    t.float    "penalty",             default: 1.0
    t.text     "description_as_html", default: ""
    t.string   "image_alt",           default: ""
    t.text     "description_as_text", default: ""
  end

  add_index "series", ["slug"], name: "index_series_on_slug", unique: true, using: :btree
  add_index "series", ["uri"], name: "index_series_on_uri", using: :btree
  add_index "series", ["user_id"], name: "index_series_on_user_id", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], name: "index_settings_on_key", using: :btree

  create_table "social_shares", force: :cascade do |t|
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

  create_table "stream_stats", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "listener_count"
    t.integer  "listener_peak"
    t.integer  "bitrate"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "stream_stats", ["venue_id"], name: "index_stream_stats_on_venue_id", using: :btree

  create_table "tag_bundles", force: :cascade do |t|
    t.string   "title_en"
    t.string   "title_de"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "group"
    t.text     "description_en"
    t.text     "description_de"
    t.boolean  "promoted",       default: false
    t.string   "icon"
  end

  add_index "tag_bundles", ["group"], name: "index_tag_bundles_on_group", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.boolean "promoted",       default: false
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
  add_index "tags", ["promoted"], name: "index_tags_on_promoted", using: :btree
  add_index "tags", ["taggings_count"], name: "index_tags_on_taggings_count", using: :btree

  create_table "talks", force: :cascade do |t|
    t.string   "title"
    t.integer  "series_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "ended_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
    t.text     "description"
    t.integer  "duration",                         default: 30
    t.string   "image_uid"
    t.text     "session"
    t.datetime "featured_from"
    t.string   "state"
    t.datetime "started_at"
    t.datetime "processed_at"
    t.integer  "play_count",                       default: 0
    t.string   "starts_at_date"
    t.string   "starts_at_time"
    t.string   "uri"
    t.string   "recording_override",  limit: 1024
    t.integer  "related_talk_id"
    t.text     "storage",                          default: "--- {}\n"
    t.string   "language",                         default: "en"
    t.string   "slug"
    t.string   "speakers"
    t.string   "user_override_uuid"
    t.text     "edit_config"
    t.float    "popularity",                       default: 1.0
    t.float    "penalty",                          default: 1.0
    t.boolean  "dryrun",                           default: false
    t.text     "social_links",                     default: "--- []"
    t.text     "listeners",                        default: "--- {}"
    t.text     "description_as_html",              default: ""
    t.string   "slides_uuid",         limit: 1024
    t.integer  "venue_id"
    t.string   "icon",                             default: "default"
    t.string   "image_alt"
    t.text     "description_as_text",              default: ""
    t.text     "processing_error"
    t.string   "forward_url"
  end

  add_index "talks", ["popularity"], name: "index_talks_on_popularity", using: :btree
  add_index "talks", ["slug"], name: "index_talks_on_slug", unique: true, using: :btree
  add_index "talks", ["uri"], name: "index_talks_on_uri", using: :btree
  add_index "talks", ["venue_id"], name: "index_talks_on_venue_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.string   "type"
    t.string   "state"
    t.text     "details"
    t.integer  "source_id"
    t.string   "source_type"
    t.datetime "failed_at"
    t.datetime "processed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["source_type", "source_id"], name: "index_transactions_on_source_type_and_source_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
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
    t.string   "slug"
    t.datetime "last_request_at"
    t.string   "header_uid"
    t.string   "avatar_uid"
    t.text     "about",                  default: ""
    t.string   "timezone"
    t.string   "website"
    t.string   "authentication_token"
    t.integer  "default_series_id"
    t.string   "summary"
    t.float    "penalty",                default: 1.0
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "credits",                default: 0
    t.integer  "purchases_count",        default: 0
    t.string   "referrer"
    t.text     "about_as_html",          default: ""
    t.boolean  "paying",                 default: false
    t.datetime "featured_from"
    t.datetime "featured_until"
    t.string   "image_alt",              default: ""
    t.text     "about_as_text",          default: ""
    t.string   "contact_email"
    t.string   "facebook"
    t.string   "twitter"
    t.integer  "default_venue_id"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["default_venue_id"], name: "index_users_on_default_venue_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["purchases_count"], name: "index_users_on_purchases_count", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "venues", force: :cascade do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "user_id"
    t.text     "options",                       default: "--- {}\n"
    t.decimal  "lat",                           default: 47.374707
    t.decimal  "long",                          default: 8.5249116
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
    t.string   "client_token"
    t.string   "instance_id"
    t.string   "public_ip_address"
    t.string   "stream_url"
    t.string   "mount_point"
    t.string   "source_password"
    t.string   "admin_password"
    t.string   "state"
    t.string   "instance_type"
    t.string   "source_identifier"
    t.string   "source_ip_address"
    t.string   "emergency_phone_number"
    t.text     "street_address"
    t.integer  "estimated_number_of_listeners"
    t.datetime "started_provisioning_at"
    t.datetime "completed_provisioning_at"
    t.integer  "device_id"
    t.string   "device_name",                   default: "noop"
    t.datetime "disconnected_at"
    t.datetime "awaiting_stream_at"
  end

  add_index "venues", ["device_id"], name: "index_venues_on_device_id", using: :btree
  add_index "venues", ["slug"], name: "index_venues_on_slug", using: :btree
  add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree

  add_foreign_key "device_reports", "devices"
  add_foreign_key "devices", "organizations"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "users"
  add_foreign_key "stream_stats", "venues"
  add_foreign_key "talks", "venues"
  add_foreign_key "venues", "devices"
  add_foreign_key "venues", "users"
end
