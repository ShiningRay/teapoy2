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

ActiveRecord::Schema.define(version: 20150126122125) do

  create_table "admin_users", force: true do |t|
    t.string   "first_name",       default: "",    null: false
    t.string   "last_name",        default: "",    null: false
    t.string   "role",                             null: false
    t.string   "email",                            null: false
    t.boolean  "status",           default: false
    t.string   "token",                            null: false
    t.string   "salt",                             null: false
    t.string   "crypted_password",                 null: false
    t.string   "preferences"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "announcements", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_articles", id: false, force: true do |t|
    t.integer  "id",                              default: 0,         null: false
    t.string   "tag_line"
    t.text     "content"
    t.integer  "user_id",                         default: 0,         null: false
    t.datetime "created_at"
    t.string   "status",               limit: 7,  default: "pending", null: false
    t.integer  "group_id",                        default: 0,         null: false
    t.string   "comment_status",       limit: 15, default: "open",    null: false
    t.integer  "ip",                              default: 0,         null: false
    t.boolean  "anonymous",                       default: false,     null: false
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "source"
    t.string   "title"
    t.string   "email"
    t.datetime "deleted_at"
  end

  create_table "archived_comments", id: false, force: true do |t|
    t.integer  "id",                   default: 0,         null: false
    t.text     "content"
    t.integer  "article_id",                               null: false
    t.integer  "user_id",              default: 0,         null: false
    t.datetime "created_at",                               null: false
    t.string   "status",     limit: 7, default: "pending", null: false
    t.integer  "ip",                   default: 0,         null: false
    t.boolean  "anonymous",            default: false,     null: false
    t.integer  "pos"
    t.integer  "neg"
    t.integer  "floor"
    t.integer  "score"
    t.integer  "parent_id"
    t.datetime "deleted_at"
  end

  create_table "articles", force: true do |t|
    t.string   "tag_line"
    t.integer  "user_id",                   default: 0,         null: false
    t.datetime "created_at"
    t.string   "status",         limit: 7,  default: "pending", null: false
    t.integer  "group_id",                  default: 0,         null: false
    t.string   "comment_status", limit: 15, default: "open",    null: false
    t.boolean  "anonymous",                 default: false,     null: false
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "top_post_id"
    t.string   "cached_slug"
    t.integer  "score",                     default: 0
    t.integer  "posts_count",               default: 0
  end

  add_index "articles", ["cached_slug"], name: "index_articles_on_slug", using: :btree
  add_index "articles", ["group_id", "status", "created_at"], name: "created_at", using: :btree
  add_index "articles", ["group_id", "status", "updated_at"], name: "index_articles_on_group_id_and_status_and_updated_at", using: :btree
  add_index "articles", ["status", "group_id", "id"], name: "status", using: :btree

  create_table "badges", force: true do |t|
    t.string   "name",              null: false
    t.string   "title",             null: false
    t.string   "description"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  add_index "badges", ["name"], name: "index_badges_on_name", unique: true, using: :btree

  create_table "badges_users", id: false, force: true do |t|
    t.integer  "badge_id",   default: 0, null: false
    t.integer  "user_id",    default: 0, null: false
    t.datetime "created_at"
  end

  create_table "balances", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "charm",      default: 0, null: false
    t.integer  "credit",     default: 0, null: false
    t.integer  "level",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "balances", ["user_id"], name: "index_balances_on_user_id", unique: true, using: :btree

  create_table "client_applications", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "support_url"
    t.string   "callback_url"
    t.string   "key",          limit: 20
    t.string   "secret",       limit: 40
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], name: "index_client_applications_on_key", unique: true, using: :btree

  create_table "code_logs", force: true do |t|
    t.integer "user_id", null: false
    t.date    "date",    null: false
  end

  add_index "code_logs", ["user_id", "date"], name: "index_code_logs_on_user_id_and_date", unique: true, using: :btree

  create_table "comment_sequence", id: false, force: true do |t|
    t.integer "article_id", null: false
    t.integer "floor",      null: false
  end

  create_table "conversations", force: true do |t|
    t.integer  "owner_id",                   null: false
    t.integer  "target_id",                  null: false
    t.integer  "messages_count", default: 0
    t.string   "last_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["owner_id", "target_id"], name: "index_conversations_on_owner_id_and_target_id", unique: true, using: :btree

  create_table "daily_statistics", force: true do |t|
    t.datetime "record_data"
    t.integer  "login_count"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0
    t.integer  "attempts",   default: 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "devices", force: true do |t|
    t.string  "device_id"
    t.string  "token"
    t.integer "user_id"
  end

  add_index "devices", ["device_id"], name: "index_devices_on_device_id", using: :btree
  add_index "devices", ["token"], name: "index_devices_on_token", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "friendships", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "friend_id",  null: false
    t.datetime "created_at"
  end

  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true, using: :btree

  create_table "groups", force: true do |t|
    t.string   "name",                               null: false
    t.string   "description"
    t.datetime "created_at"
    t.string   "alias"
    t.text     "options"
    t.integer  "owner_id"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
    t.boolean  "private",           default: false
    t.integer  "feature",           default: 0,      null: false
    t.string   "theme"
    t.string   "status",            default: "open", null: false
    t.integer  "score",             default: 0,      null: false
    t.boolean  "hide",              default: false,  null: false
    t.string   "domain"
  end

  add_index "groups", ["alias"], name: "index_groups_on_alias", unique: true, using: :btree
  add_index "groups", ["domain"], name: "index_groups_on_domain", unique: true, using: :btree
  add_index "groups", ["hide"], name: "index_groups_on_hide", using: :btree

  create_table "inboxes", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id",    default: 0
    t.integer  "article_id"
    t.integer  "score",      default: 0
    t.boolean  "read",       default: false
    t.binary   "post_ids"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "inboxes", ["group_id", "user_id", "article_id"], name: "index_inboxes_on_group_id_and_user_id_and_article_id", unique: true, using: :btree
  add_index "inboxes", ["read", "score"], name: "index_inboxes_on_read_and_score", using: :btree

  create_table "invitation_codes", force: true do |t|
    t.string   "code",         null: false
    t.integer  "applicant_id", null: false
    t.integer  "consumer_id"
    t.datetime "created_at"
    t.datetime "consumed_at"
    t.datetime "updated_at"
  end

  add_index "invitation_codes", ["applicant_id"], name: "index_invitation_codes_on_applicant_id", using: :btree
  add_index "invitation_codes", ["code"], name: "index_invitation_codes_on_code", unique: true, using: :btree

  create_table "list_items", force: true do |t|
    t.integer  "article_id",             null: false
    t.integer  "list_id",                null: false
    t.integer  "position",   default: 0, null: false
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: true do |t|
    t.string   "name",                       null: false
    t.integer  "user_id",                    null: false
    t.boolean  "private",    default: false, null: false
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: true do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "owner_id",                     null: false
    t.integer  "sender_id",                    null: false
    t.integer  "recipient_id",                 null: false
    t.text     "content",                      null: false
    t.boolean  "read",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages", ["owner_id", "sender_id", "read"], name: "owner_id", using: :btree

  create_table "name_logs", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
  end

  add_index "name_logs", ["user_id"], name: "index_name_logs_on_user_id", using: :btree

  create_table "notifications", force: true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",         default: false, null: false
    t.string   "scope"
    t.string   "subject_type"
    t.integer  "subject_id"
    t.integer  "count",        default: 1
  end

  add_index "notifications", ["scope"], name: "index_notifications_on_scope", using: :btree
  add_index "notifications", ["subject_type", "subject_id"], name: "index_notifications_on_subject_type_and_subject_id", using: :btree
  add_index "notifications", ["user_id", "scope", "subject_type", "subject_id"], name: "key1", using: :btree
  add_index "notifications", ["user_id", "scope"], name: "scope", unique: true, using: :btree

  create_table "oauth_nonces", force: true do |t|
    t.string   "nonce"
    t.integer  "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true, using: :btree

  create_table "oauth_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "type",                  limit: 20
    t.integer  "client_application_id"
    t.string   "token",                 limit: 20
    t.string   "secret",                limit: 40
    t.string   "callback_url"
    t.string   "verifier",              limit: 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], name: "index_oauth_tokens_on_token", unique: true, using: :btree

  create_table "persistence_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.string   "agent"
    t.decimal  "ip",         precision: 12, scale: 0, default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "persistence_tokens", ["token"], name: "index_persistence_tokens_on_token", unique: true, using: :btree
  add_index "persistence_tokens", ["updated_at"], name: "index_persistence_tokens_on_updated_at", using: :btree
  add_index "persistence_tokens", ["user_id"], name: "index_persistence_tokens_on_user_id", using: :btree

  create_table "post_reposts", force: true do |t|
    t.integer "original_group_id"
    t.integer "original_article_id"
    t.integer "original_id"
    t.integer "group_id"
    t.integer "article_id"
    t.integer "repost_id"
    t.integer "sharer_id"
  end

  add_index "post_reposts", ["original_id", "group_id"], name: "key", unique: true, using: :btree
  add_index "post_reposts", ["original_id"], name: "index_post_reposts_on_original_id", using: :btree
  add_index "post_reposts", ["repost_id"], name: "index_post_reposts_on_repost_id", using: :btree
  add_index "post_reposts", ["sharer_id"], name: "index_post_reposts_on_sharer_id", using: :btree

  create_table "posts", force: true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "ip"
    t.string   "type"
    t.integer  "group_id"
    t.integer  "article_id"
    t.integer  "floor"
    t.integer  "neg"
    t.integer  "pos"
    t.integer  "score"
    t.boolean  "anonymous"
    t.string   "status"
    t.binary   "meta"
    t.string   "ancestry"
    t.integer  "ancestry_depth", default: 0
  end

  add_index "posts", ["ancestry"], name: "index_posts_on_ancestry", using: :btree
  add_index "posts", ["article_id", "floor"], name: "article_id", unique: true, using: :btree
  add_index "posts", ["group_id", "article_id", "floor"], name: "pk", unique: true, using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_reshare_and_parent_id", using: :btree

  create_table "preferences", force: true do |t|
    t.string   "name",       null: false
    t.integer  "owner_id",   null: false
    t.string   "owner_type", null: false
    t.integer  "group_id"
    t.string   "group_type"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], name: "index_preferences_on_owner_and_name_and_preference", unique: true, using: :btree

  create_table "profiles", force: true do |t|
    t.integer "user_id"
    t.text    "value"
  end

  create_table "quest_logs", force: true do |t|
    t.string  "quest_id",                                 null: false
    t.integer "user_id",                                  null: false
    t.string  "status",   limit: 12, default: "accepted"
  end

  create_table "queue", force: true do |t|
  end

  create_table "ratings", force: true do |t|
    t.string   "post_id",    limit: 24, default: "0", null: false
    t.integer  "user_id",               default: 0,   null: false
    t.integer  "score",                 default: 0,   null: false
    t.datetime "created_at",                          null: false
  end

  add_index "ratings", ["created_at"], name: "created_at", using: :btree
  add_index "ratings", ["post_id", "user_id"], name: "index_ratings_on_article_id_and_user_id", unique: true, using: :btree
  add_index "ratings", ["score"], name: "index_ratings_on_score", using: :btree

  create_table "read_statuses", force: true do |t|
    t.integer  "user_id",                null: false
    t.integer  "group_id"
    t.integer  "article_id",             null: false
    t.integer  "read_to",    default: 0
    t.datetime "read_at"
    t.integer  "updates",    default: 0
  end

  add_index "read_statuses", ["user_id", "group_id", "article_id", "read_to"], name: "total_index", using: :btree
  add_index "read_statuses", ["user_id", "group_id", "article_id"], name: "alter_pk", unique: true, using: :btree

  create_table "references", force: true do |t|
    t.integer  "source_id"
    t.integer  "target_id"
    t.string   "relation_type"
    t.boolean  "detected"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "reports", force: true do |t|
    t.string   "target_type"
    t.integer  "target_id"
    t.text     "info"
    t.integer  "report_times"
    t.integer  "operator_id"
    t.string   "result"
    t.datetime "operated_at"
  end

  create_table "reputation_logs", force: true do |t|
    t.integer  "reputation_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.string   "post_id",       limit: 24, default: "0", null: false
    t.integer  "amount"
    t.string   "reason"
    t.date     "created_on"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "reputation_logs", ["created_on"], name: "index_reputation_logs_on_created_on", using: :btree
  add_index "reputation_logs", ["group_id", "user_id"], name: "index_reputation_logs_on_group_id_and_user_id", using: :btree
  add_index "reputation_logs", ["post_id"], name: "index_reputation_logs_on_post_id", using: :btree
  add_index "reputation_logs", ["reputation_id"], name: "index_reputation_logs_on_reputation_id", using: :btree

  create_table "reputations", force: true do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.integer "value",    default: 0
    t.string  "state",    default: "neutral"
    t.boolean "hide",     default: false
  end

  add_index "reputations", ["group_id", "user_id"], name: "index_reputations_on_group_id_and_user_id", unique: true, using: :btree

  create_table "rewards", force: true do |t|
    t.integer  "rewarder_id",                            null: false
    t.string   "post_id",     limit: 24
    t.integer  "winner_id",                              null: false
    t.integer  "amount"
    t.boolean  "anonymous",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "rewards", ["rewarder_id", "post_id"], name: "index_rewards_on_rewarder_id_and_post_id", unique: true, using: :btree

  create_table "roles", force: true do |t|
    t.string "name"
  end

  create_table "roles_users", id: false, force: true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true, using: :btree

  create_table "salaries", force: true do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.string   "type"
    t.date     "created_on"
    t.integer  "status",     default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "salaries", ["type", "created_on"], name: "salary", using: :btree

  create_table "settings", force: true do |t|
    t.string "key",   null: false
    t.text   "value", null: false
  end

  add_index "settings", ["key"], name: "index_settings_on_key", unique: true, using: :btree

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "slugs", force: true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                  default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], name: "index_slugs_on_n_s_s_and_s", unique: true, using: :btree
  add_index "slugs", ["sluggable_id"], name: "index_slugs_on_sluggable_id", using: :btree

  create_table "statuses", force: true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.integer  "subscriber_id"
    t.integer  "publication_id"
    t.string   "publication_type", limit: 32
    t.datetime "viewed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unread_count",                default: 0, null: false
  end

  add_index "subscriptions", ["subscriber_id", "publication_id", "publication_type"], name: "index_subscriptions_on_subscriber_id_and_article_id", unique: true, using: :btree
  add_index "subscriptions", ["updated_at"], name: "index_subscriptions_on_updated_at", using: :btree
  add_index "subscriptions", ["viewed_at"], name: "index_subscriptions_on_viewed_at", using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string "name"
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "ticket_types", force: true do |t|
    t.string  "name",                    null: false
    t.string  "description"
    t.integer "weight",      default: 0, null: false
    t.boolean "need_reason"
    t.string  "callback"
  end

  create_table "tickets", force: true do |t|
    t.integer  "user_id",        null: false
    t.integer  "article_id",     null: false
    t.integer  "ticket_type_id"
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "viewed_at"
  end

  add_index "tickets", ["article_id"], name: "article_id", using: :btree
  add_index "tickets", ["user_id", "article_id", "ticket_type_id", "correct"], name: "full_idx", using: :btree
  add_index "tickets", ["user_id", "article_id"], name: "index_tickets_on_user_id_and_article_id", unique: true, using: :btree

  create_table "transactions", force: true do |t|
    t.integer  "balance_id",             null: false
    t.integer  "amount",     default: 0, null: false
    t.string   "reason"
    t.datetime "created_at"
    t.string   "deal_type"
    t.integer  "deal_id"
  end

  add_index "transactions", ["balance_id", "created_at"], name: "index_transactions_on_balance_id_and_created_at", using: :btree
  add_index "transactions", ["deal_type", "deal_id"], name: "index_transactions_on_deal_type_and_deal_id", using: :btree

  create_table "user_stats", force: true do |t|
    t.integer "user_id",                        null: false
    t.integer "anonymous_comments", default: 0, null: false
    t.integer "public_comments",    default: 0, null: false
    t.integer "public_sofas",       default: 0, null: false
    t.integer "public_articles",    default: 0, null: false
    t.integer "anonymous_articles", default: 0, null: false
  end

  create_table "user_tokens", force: true do |t|
    t.integer  "user_id"
    t.string   "client_name"
    t.string   "token_key"
    t.string   "token_secret"
    t.datetime "expires_at"
    t.string   "uid"
  end

  add_index "user_tokens", ["client_name", "token_key", "token_secret"], name: "key", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "login",                                                     null: false
    t.string   "email",                                                     null: false
    t.string   "crypted_password",                                          null: false
    t.string   "salt",                                                      null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "remember_token",                        default: "",        null: false
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "state",                                 default: "passive"
    t.datetime "deleted_at"
    t.string   "name",                      limit: 100
    t.string   "persistence_token",                                         null: false
    t.integer  "login_count",                           default: 0
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "perishable_token",                      default: "",        null: false
    t.string   "avatar_fingerprint"
  end

  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["login"], name: "login", unique: true, using: :btree
  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token", using: :btree
  add_index "users", ["remember_token"], name: "remember_token", using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree

end
