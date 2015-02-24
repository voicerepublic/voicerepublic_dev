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

ActiveRecord::Schema.define(version: 20150210154542) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

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

  create_table "comments", force: true do |t|
    t.text     "content"
    t.integer  "user_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

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

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.integer  "talk_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["talk_id"], name: "index_messages_on_talk_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "participations", force: true do |t|
    t.integer  "venue_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree
  add_index "participations", ["venue_id"], name: "index_participations_on_venue_id", using: :btree

  create_table "pg_search_documents", force: true do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pg_search_documents", ["content"], name: "index_pg_search_documents_on_content", using: :btree

  create_table "reminders", force: true do |t|
    t.integer  "user_id"
    t.integer  "rememberable_id"
    t.string   "rememberable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["rememberable_id", "rememberable_type"], name: "index_reminders_on_rememberable_id_and_rememberable_type", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "settings", force: true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], name: "index_settings_on_key", using: :btree

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

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.boolean "category",       default: false
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["category"], name: "index_tags_on_category", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
  add_index "tags", ["taggings_count"], name: "index_tags_on_taggings_count", using: :btree

  create_table "talks", force: true do |t|
    t.string   "title"
    t.integer  "venue_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "ended_at"
    t.boolean  "collect",            default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser"
    t.text     "description"
    t.integer  "duration",           default: 30
    t.string   "image_uid"
    t.text     "session"
    t.datetime "featured_from"
    t.string   "state"
    t.datetime "started_at"
    t.datetime "processed_at"
    t.integer  "play_count",         default: 0
    t.string   "starts_at_date"
    t.string   "starts_at_time"
    t.string   "uri"
    t.string   "recording_override"
    t.integer  "related_talk_id"
    t.text     "storage",            default: "--- {}\n"
    t.string   "grade"
    t.string   "language",           default: "en"
    t.string   "slug"
    t.string   "speakers"
    t.string   "slides_uid"
    t.text     "edit_config"
    t.string   "user_override_uuid"
    t.float    "popularity",         default: 1.0
    t.float    "penalty",            default: 1.0
  end

  add_index "talks", ["grade"], name: "index_talks_on_grade", using: :btree
  add_index "talks", ["popularity"], name: "index_talks_on_popularity", using: :btree
  add_index "talks", ["slug"], name: "index_talks_on_slug", unique: true, using: :btree
  add_index "talks", ["uri"], name: "index_talks_on_uri", using: :btree

  create_table "users", force: true do |t|
    t.string   "firstname"
    t.string   "lastname"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
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
    t.boolean  "guest"
    t.string   "header_uid"
    t.string   "avatar_uid"
    t.text     "about",                  default: ""
    t.string   "timezone"
    t.string   "website"
    t.string   "authentication_token"
    t.boolean  "conference"
    t.integer  "default_venue_id"
    t.string   "summary"
    t.float    "penalty",                default: 1.0
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "venues", force: true do |t|
    t.text     "description"
    t.string   "title"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.string   "teaser"
    t.integer  "user_id"
    t.text     "options",     default: "--- {}\n"
    t.string   "image_uid"
    t.string   "uri"
    t.string   "slug"
    t.float    "penalty",     default: 1.0
  end

  add_index "venues", ["slug"], name: "index_venues_on_slug", unique: true, using: :btree
  add_index "venues", ["uri"], name: "index_venues_on_uri", using: :btree
  add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree

end
