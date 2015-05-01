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

ActiveRecord::Schema.define(version: 20150501165244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
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

  create_table "articles", force: :cascade do |t|
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

  create_table "balance_accounts", force: :cascade do |t|
    t.string   "currency",      limit: 255
    t.integer  "balance_cents",             default: 0
    t.integer  "revenue_cents",             default: 0
    t.integer  "user_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  create_table "balance_check_in_orders", force: :cascade do |t|
    t.integer  "balance_account_id"
    t.boolean  "completed"
    t.datetime "completed_at"
    t.string   "currency",           limit: 255
    t.integer  "amount_cents"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "category_translations", force: :cascade do |t|
    t.integer  "category_id"
    t.string   "locale",      limit: 255
    t.string   "name",        limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "category_translations", ["category_id"], name: "index_category_translations_on_category_id", using: :btree
  add_index "category_translations", ["locale"], name: "index_category_translations_on_locale", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id",                      null: false
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "commentable_id"
    t.string   "commentable_type", limit: 255
  end

  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["commentable_type"], name: "index_comments_on_commentable_type", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "user_1_id"
    t.integer  "user_2_id"
    t.integer  "offset_1"
    t.integer  "offset_2"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "conversations", ["user_1_id"], name: "index_conversations_on_user_1_id", using: :btree
  add_index "conversations", ["user_2_id"], name: "index_conversations_on_user_2_id", using: :btree

  create_table "credit_accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "prepaid_amount"
    t.integer  "revenue_amount"
    t.string   "currency",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "events", force: :cascade do |t|
    t.datetime "start_time"
    t.integer  "duration"
    t.integer  "venue_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.boolean  "record"
    t.string   "title",      limit: 255, null: false
    t.string   "recording",  limit: 255
    t.datetime "end_at"
  end

  add_index "events", ["start_time"], name: "index_events_on_start_time", using: :btree
  add_index "events", ["venue_id"], name: "index_events_on_venue_id", using: :btree

  create_table "kblog_articles", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "content"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "klu_images", force: :cascade do |t|
    t.text     "description"
    t.integer  "klu_id"
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "klus", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "description"
    t.string   "available_at_times", limit: 255
    t.integer  "user_id"
    t.boolean  "published",                      default: false
    t.integer  "category_id"
    t.string   "type",               limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "charge_type",        limit: 255, default: "free"
    t.string   "currency",           limit: 255
    t.integer  "charge_cents",                   default: 0
  end

  add_index "klus", ["charge_type"], name: "index_klus_on_charge_type", using: :btree

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
    t.string   "key",        limit: 255
    t.float    "value"
    t.datetime "created_at"
  end

  create_table "notification_bases", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "klu_id"
    t.integer  "other_id"
    t.string   "url",              limit: 255
    t.string   "type",             limit: 255
    t.boolean  "read",                         default: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "video_session_id"
    t.string   "anon_id",          limit: 255
  end

  add_index "notification_bases", ["user_id"], name: "index_notification_bases_on_user_id", using: :btree

  create_table "participant_bases", force: :cascade do |t|
    t.string   "type",                      limit: 255
    t.integer  "video_session_id"
    t.datetime "entered_timestamp"
    t.datetime "left_timestamp"
    t.string   "room_url",                  limit: 255
    t.string   "video_session_role",        limit: 255
    t.string   "user_cookie_session_id",    limit: 255
    t.integer  "user_id"
    t.integer  "seconds_online",                        default: 0
    t.datetime "last_pay_tick_timestamp"
    t.integer  "pay_tick_counter",                      default: 0
    t.datetime "payment_started_timestamp"
    t.datetime "payment_stopped_timestamp"
    t.datetime "created_at",                                        null: false
    t.datetime "updated_at",                                        null: false
  end

  create_table "participations", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "participations", ["user_id"], name: "index_participations_on_user_id", using: :btree
  add_index "participations", ["venue_id"], name: "index_participations_on_venue_id", using: :btree

  create_table "paypal_payments", force: :cascade do |t|
    t.text     "params"
    t.integer  "check_in_order_id"
    t.string   "status",            limit: 255
    t.integer  "amount_cents"
    t.string   "tact_id",           limit: 255
    t.string   "currency",          limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text     "content"
    t.integer  "searchable_id"
    t.string   "searchable_type", limit: 255
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

  create_table "ratings", force: :cascade do |t|
    t.integer  "rateable_id"
    t.integer  "user_id"
    t.string   "rateable_type", limit: 255
    t.text     "content"
    t.integer  "score",                     default: 0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "ratings", ["rateable_id"], name: "index_ratings_on_rateable_id", using: :btree
  add_index "ratings", ["rateable_type"], name: "index_ratings_on_rateable_type", using: :btree
  add_index "ratings", ["user_id"], name: "index_ratings_on_user_id", using: :btree

  create_table "refinery_images", force: :cascade do |t|
    t.string   "image_mime_type", limit: 255
    t.string   "image_name",      limit: 255
    t.integer  "image_size"
    t.integer  "image_width"
    t.integer  "image_height"
    t.string   "image_uid",       limit: 255
    t.string   "image_ext",       limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "refinery_page_part_translations", force: :cascade do |t|
    t.integer  "refinery_page_part_id"
    t.string   "locale",                limit: 255
    t.text     "body"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
  end

  add_index "refinery_page_part_translations", ["locale"], name: "index_refinery_page_part_translations_on_locale", using: :btree
  add_index "refinery_page_part_translations", ["refinery_page_part_id"], name: "index_f9716c4215584edbca2557e32706a5ae084a15ef", using: :btree

  create_table "refinery_page_parts", force: :cascade do |t|
    t.integer  "refinery_page_id"
    t.string   "title",            limit: 255
    t.text     "body"
    t.integer  "position"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "refinery_page_parts", ["id"], name: "index_refinery_page_parts_on_id", using: :btree
  add_index "refinery_page_parts", ["refinery_page_id"], name: "index_refinery_page_parts_on_refinery_page_id", using: :btree

  create_table "refinery_page_translations", force: :cascade do |t|
    t.integer  "refinery_page_id"
    t.string   "locale",           limit: 255
    t.string   "title",            limit: 255
    t.string   "custom_slug",      limit: 255
    t.string   "menu_title",       limit: 255
    t.string   "slug",             limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "refinery_page_translations", ["locale"], name: "index_refinery_page_translations_on_locale", using: :btree
  add_index "refinery_page_translations", ["refinery_page_id"], name: "index_d079468f88bff1c6ea81573a0d019ba8bf5c2902", using: :btree

  create_table "refinery_pages", force: :cascade do |t|
    t.integer  "parent_id"
    t.string   "path",                limit: 255
    t.string   "slug",                limit: 255
    t.boolean  "show_in_menu",                    default: true
    t.string   "link_url",            limit: 255
    t.string   "menu_match",          limit: 255
    t.boolean  "deletable",                       default: true
    t.boolean  "draft",                           default: false
    t.boolean  "skip_to_first_child",             default: false
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "view_template",       limit: 255
    t.string   "layout_template",     limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "refinery_pages", ["depth"], name: "index_refinery_pages_on_depth", using: :btree
  add_index "refinery_pages", ["id"], name: "index_refinery_pages_on_id", using: :btree
  add_index "refinery_pages", ["lft"], name: "index_refinery_pages_on_lft", using: :btree
  add_index "refinery_pages", ["parent_id"], name: "index_refinery_pages_on_parent_id", using: :btree
  add_index "refinery_pages", ["rgt"], name: "index_refinery_pages_on_rgt", using: :btree

  create_table "refinery_resources", force: :cascade do |t|
    t.string   "file_mime_type", limit: 255
    t.string   "file_name",      limit: 255
    t.integer  "file_size"
    t.string   "file_uid",       limit: 255
    t.string   "file_ext",       limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "refinery_roles", force: :cascade do |t|
    t.string "title", limit: 255
  end

  create_table "refinery_roles_users", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "refinery_roles_users", ["role_id", "user_id"], name: "index_refinery_roles_users_on_role_id_and_user_id", using: :btree
  add_index "refinery_roles_users", ["user_id", "role_id"], name: "index_refinery_roles_users_on_user_id_and_role_id", using: :btree

  create_table "refinery_user_plugins", force: :cascade do |t|
    t.integer "user_id"
    t.string  "name",     limit: 255
    t.integer "position"
  end

  add_index "refinery_user_plugins", ["name"], name: "index_refinery_user_plugins_on_name", using: :btree
  add_index "refinery_user_plugins", ["user_id", "name"], name: "index_refinery_user_plugins_on_user_id_and_name", unique: true, using: :btree

  create_table "refinery_users", force: :cascade do |t|
    t.string   "username",               limit: 255, null: false
    t.string   "email",                  limit: 255, null: false
    t.string   "encrypted_password",     limit: 255, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.integer  "sign_in_count"
    t.datetime "remember_created_at"
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "refinery_users", ["id"], name: "index_refinery_users_on_id", using: :btree

  create_table "reminders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "rememberable_id"
    t.string   "rememberable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reminders", ["rememberable_id", "rememberable_type"], name: "index_reminders_on_rememberable_id_and_rememberable_type", using: :btree
  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id", using: :btree

  create_table "seo_meta", force: :cascade do |t|
    t.integer  "seo_meta_id"
    t.string   "seo_meta_type",    limit: 255
    t.string   "browser_title",    limit: 255
    t.string   "meta_keywords",    limit: 255
    t.text     "meta_description"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "seo_meta", ["id"], name: "index_seo_meta_on_id", using: :btree
  add_index "seo_meta", ["seo_meta_id", "seo_meta_type"], name: "index_seo_meta_on_seo_meta_id_and_seo_meta_type", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], name: "index_settings_on_key", using: :btree

  create_table "social_shares", force: :cascade do |t|
    t.integer  "shareable_id"
    t.string   "shareable_type", limit: 255
    t.string   "request_ip",     limit: 255
    t.string   "user_agent",     limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "social_network", limit: 255
  end

  add_index "social_shares", ["shareable_id", "shareable_type"], name: "index_social_shares_on_shareable_id_and_shareable_type", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id"
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.boolean "category",                   default: false
    t.integer "taggings_count",             default: 0
  end

  add_index "tags", ["category"], name: "index_tags_on_category", using: :btree
  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree
  add_index "tags", ["taggings_count"], name: "index_tags_on_taggings_count", using: :btree

  create_table "talks", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.integer  "venue_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "ended_at"
    t.boolean  "collect",                        default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "teaser",             limit: 255
    t.text     "description"
    t.integer  "duration",                       default: 30
    t.string   "image_uid",          limit: 255
    t.text     "session"
    t.datetime "featured_from"
    t.string   "state",              limit: 255
    t.datetime "started_at"
    t.datetime "processed_at"
    t.integer  "play_count",                     default: 0
    t.string   "starts_at_date",     limit: 255
    t.string   "starts_at_time",     limit: 255
    t.string   "uri",                limit: 255
    t.string   "recording_override", limit: 255
    t.integer  "related_talk_id"
    t.text     "storage",                        default: "--- {}\n"
    t.string   "grade",              limit: 255
    t.string   "language",           limit: 255, default: "en"
    t.string   "slug",               limit: 255
    t.string   "speakers",           limit: 255
    t.string   "user_override_uuid", limit: 255
    t.text     "edit_config"
    t.float    "popularity",                     default: 1.0
    t.float    "penalty",                        default: 1.0
    t.boolean  "dryrun",                         default: false
    t.text     "social_links",                   default: "--- []"
    t.text     "listeners",                      default: "--- {}"
  end

  add_index "talks", ["grade"], name: "index_talks_on_grade", using: :btree
  add_index "talks", ["popularity"], name: "index_talks_on_popularity", using: :btree
  add_index "talks", ["slug"], name: "index_talks_on_slug", unique: true, using: :btree
  add_index "talks", ["uri"], name: "index_talks_on_uri", using: :btree

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

  create_table "transfers", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "video_session_id"
    t.integer  "duration"
    t.integer  "transfer_charge_cents"
    t.string   "transfer_charge_currency",      limit: 255
    t.integer  "transfer_gross_cents"
    t.string   "transfer_gross_currency",       limit: 255
    t.integer  "video_session_charge_cents"
    t.string   "video_session_charge_currency", limit: 255
    t.decimal  "exchange_rate",                             precision: 10, scale: 5
    t.string   "video_session_klu_name",        limit: 255
    t.datetime "created_at",                                                         null: false
    t.datetime "updated_at",                                                         null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "firstname",              limit: 255
    t.string   "lastname",               limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "email",                  limit: 255, default: "",  null: false
    t.string   "encrypted_password",     limit: 255, default: "",  null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.text     "slug"
    t.datetime "last_request_at"
    t.string   "image_file_name",        limit: 255
    t.string   "image_content_type",     limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "header_uid",             limit: 255
    t.string   "avatar_uid",             limit: 255
    t.text     "about",                              default: ""
    t.string   "timezone",               limit: 255
    t.string   "website",                limit: 255
    t.boolean  "conference"
    t.string   "authentication_token",   limit: 255
    t.integer  "default_venue_id"
    t.string   "summary",                limit: 255
    t.float    "penalty",                            default: 1.0
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "credits",                            default: 0
    t.integer  "purchases_count",                    default: 0
    t.string   "referrer"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["purchases_count"], name: "index_users_on_purchases_count", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["slug"], name: "index_users_on_slug", unique: true, using: :btree

  create_table "venue_klus", force: :cascade do |t|
    t.integer  "venue_id"
    t.integer  "klu_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "venue_klus", ["venue_id"], name: "index_venue_klus_on_venue_id", using: :btree

  create_table "venues", force: :cascade do |t|
    t.text     "description"
    t.string   "title",       limit: 255
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.string   "teaser",      limit: 255
    t.integer  "user_id"
    t.text     "options",                 default: "--- {}\n"
    t.string   "image_uid",   limit: 255
    t.string   "uri",         limit: 255
    t.string   "slug",        limit: 255
    t.float    "penalty",                 default: 1.0
  end

  add_index "venues", ["slug"], name: "index_venues_on_slug", unique: true, using: :btree
  add_index "venues", ["uri"], name: "index_venues_on_uri", using: :btree
  add_index "venues", ["user_id"], name: "index_venues_on_user_id", using: :btree

  create_table "video_rooms", force: :cascade do |t|
    t.integer  "video_server_id"
    t.integer  "video_session_id"
    t.integer  "participant_count"
    t.string   "video_system_room_id", limit: 255
    t.string   "name",                 limit: 255
    t.string   "guest_password",       limit: 255
    t.string   "host_password",        limit: 255
    t.string   "welcome_msg",          limit: 255
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "video_rooms", ["video_system_room_id"], name: "index_video_rooms_on_video_system_room_id", unique: true, using: :btree

  create_table "video_servers", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "url",        limit: 255
    t.string   "salt",       limit: 255
    t.boolean  "activated"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "video_session_bases", force: :cascade do |t|
    t.datetime "end_timestamp"
    t.datetime "begin_timestamp"
    t.string   "video_system_session_id", limit: 255
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "klu_id"
    t.string   "type",                    limit: 255
  end

end
