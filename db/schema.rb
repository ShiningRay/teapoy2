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

ActiveRecord::Schema.define(version: 20150713092952) do

  create_table "admin_users", force: :cascade do |t|
    t.string   "first_name",       limit: 255, default: "",    null: false
    t.string   "last_name",        limit: 255, default: "",    null: false
    t.string   "role",             limit: 255,                 null: false
    t.string   "email",            limit: 255,                 null: false
    t.boolean  "status",                       default: false
    t.string   "token",            limit: 255,                 null: false
    t.string   "salt",             limit: 255,                 null: false
    t.string   "crypted_password", limit: 255,                 null: false
    t.string   "preferences",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree

  create_table "announcements", force: :cascade do |t|
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "archived_articles", id: false, force: :cascade do |t|
    t.integer  "id",                   limit: 4,     default: 0,         null: false
    t.string   "tag_line",             limit: 255
    t.text     "content",              limit: 65535
    t.integer  "user_id",              limit: 4,     default: 0,         null: false
    t.datetime "created_at"
    t.string   "status",               limit: 7,     default: "pending", null: false
    t.integer  "group_id",             limit: 4,     default: 0,         null: false
    t.string   "comment_status",       limit: 15,    default: "open",    null: false
    t.integer  "ip",                   limit: 4,     default: 0,         null: false
    t.boolean  "anonymous",                          default: false,     null: false
    t.datetime "updated_at"
    t.string   "picture_file_name",    limit: 255
    t.string   "picture_content_type", limit: 255
    t.integer  "picture_file_size",    limit: 4
    t.datetime "picture_updated_at"
    t.string   "source",               limit: 255
    t.string   "title",                limit: 255
    t.string   "email",                limit: 255
    t.datetime "deleted_at"
  end

  create_table "archived_comments", id: false, force: :cascade do |t|
    t.integer  "id",         limit: 4,     default: 0,         null: false
    t.text     "content",    limit: 65535
    t.integer  "article_id", limit: 4,                         null: false
    t.integer  "user_id",    limit: 4,     default: 0,         null: false
    t.datetime "created_at",                                   null: false
    t.string   "status",     limit: 7,     default: "pending", null: false
    t.integer  "ip",         limit: 4,     default: 0,         null: false
    t.boolean  "anonymous",                default: false,     null: false
    t.integer  "pos",        limit: 4
    t.integer  "neg",        limit: 4
    t.integer  "floor",      limit: 4
    t.integer  "score",      limit: 4
    t.integer  "parent_id",  limit: 4
    t.datetime "deleted_at"
  end

  create_table "attachments", force: :cascade do |t|
    t.integer "uploader_id",  limit: 4,   default: 0, null: false
    t.string  "post_id",      limit: 32
    t.string  "file",         limit: 255
    t.string  "content_type", limit: 20
    t.integer "file_size",    limit: 4
    t.integer "width",        limit: 4,   default: 0, null: false
    t.integer "height",       limit: 4,   default: 0, null: false
    t.string  "original_url", limit: 255
    t.string  "checksum",     limit: 32
  end

  add_index "attachments", ["post_id"], name: "index_attachments_on_post_id", using: :btree
  add_index "attachments", ["uploader_id"], name: "index_attachments_on_uploader_id", using: :btree

  create_table "badges", force: :cascade do |t|
    t.string   "name",              limit: 255, null: false
    t.string   "title",             limit: 255, null: false
    t.string   "description",       limit: 255
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size",    limit: 4
    t.datetime "icon_updated_at"
  end

  add_index "badges", ["name"], name: "index_badges_on_name", unique: true, using: :btree

  create_table "badges_users", id: false, force: :cascade do |t|
    t.integer  "badge_id",   limit: 4, default: 0, null: false
    t.integer  "user_id",    limit: 4, default: 0, null: false
    t.datetime "created_at"
  end

  create_table "balances", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,             null: false
    t.integer  "charm",      limit: 4, default: 0, null: false
    t.integer  "credit",     limit: 4, default: 0, null: false
    t.integer  "level",      limit: 4, default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "balances", ["user_id"], name: "index_balances_on_user_id", unique: true, using: :btree

  create_table "client_applications", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "url",          limit: 255
    t.string   "support_url",  limit: 255
    t.string   "callback_url", limit: 255
    t.string   "key",          limit: 20
    t.string   "secret",       limit: 40
    t.integer  "user_id",      limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "client_applications", ["key"], name: "index_client_applications_on_key", unique: true, using: :btree

  create_table "code_logs", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.date    "date",              null: false
  end

  add_index "code_logs", ["user_id", "date"], name: "index_code_logs_on_user_id_and_date", unique: true, using: :btree

  create_table "comment_sequence", id: false, force: :cascade do |t|
    t.integer "article_id", limit: 4, null: false
    t.integer "floor",      limit: 4, null: false
  end

  create_table "conversations", force: :cascade do |t|
    t.integer  "owner_id",       limit: 4,               null: false
    t.integer  "target_id",      limit: 4,               null: false
    t.integer  "messages_count", limit: 4,   default: 0
    t.string   "last_content",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["owner_id", "target_id"], name: "index_conversations_on_owner_id_and_target_id", unique: true, using: :btree

  create_table "daily_statistics", force: :cascade do |t|
    t.datetime "record_data"
    t.integer  "login_count", limit: 4
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0
    t.integer  "attempts",   limit: 4,     default: 0
    t.text     "handler",    limit: 65535
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue",      limit: 255
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "devices", force: :cascade do |t|
    t.string  "device_id", limit: 255
    t.string  "token",     limit: 255
    t.integer "user_id",   limit: 4
  end

  add_index "devices", ["device_id"], name: "index_devices_on_device_id", using: :btree
  add_index "devices", ["token"], name: "index_devices_on_token", using: :btree
  add_index "devices", ["user_id"], name: "index_devices_on_user_id", using: :btree

  create_table "friendships", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "friend_id",  limit: 4, null: false
    t.datetime "created_at"
  end

  add_index "friendships", ["user_id", "friend_id"], name: "index_friendships_on_user_id_and_friend_id", unique: true, using: :btree

  create_table "group_options", force: :cascade do |t|
    t.integer "group_id",                      limit: 4,                   null: false
    t.string  "receive_group_email_frequency", limit: 255, default: "day"
    t.boolean "only_member_can_view",                      default: false
    t.boolean "only_member_can_post",                      default: false
    t.boolean "membership_need_approval",                  default: false
    t.boolean "only_member_can_reply",                     default: false
    t.boolean "topics_need_approval",                      default: false
    t.boolean "comments_need_approval",                    default: false
    t.boolean "force_comments_anonymous",                  default: false
    t.boolean "force_anonymous",                           default: false
    t.boolean "encryption",                                default: false
    t.string  "score_algorithm",               limit: 255
    t.string  "css",                           limit: 255
    t.string  "seo_keywords",                  limit: 255
    t.string  "seo_description",               limit: 255
    t.string  "background",                    limit: 255
    t.string  "background_style",              limit: 255
    t.boolean "guest_can_post",                            default: false
    t.boolean "guest_can_reply",                           default: false
  end

  add_index "group_options", ["group_id"], name: "index_group_options_on_group_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",              limit: 255,                    null: false
    t.string   "description",       limit: 255
    t.datetime "created_at"
    t.string   "alias",             limit: 255
    t.text     "options",           limit: 65535
    t.integer  "owner_id",          limit: 4
    t.string   "icon_file_name",    limit: 255
    t.string   "icon_content_type", limit: 255
    t.integer  "icon_file_size",    limit: 4
    t.datetime "icon_updated_at"
    t.boolean  "private",                         default: false
    t.integer  "feature",           limit: 4,     default: 0,      null: false
    t.string   "theme",             limit: 255
    t.string   "status",            limit: 255,   default: "open", null: false
    t.integer  "score",             limit: 4,     default: 0,      null: false
    t.boolean  "hide",                            default: false,  null: false
    t.string   "domain",            limit: 255
  end

  add_index "groups", ["alias"], name: "index_groups_on_alias", unique: true, using: :btree
  add_index "groups", ["domain"], name: "index_groups_on_domain", unique: true, using: :btree
  add_index "groups", ["hide"], name: "index_groups_on_hide", using: :btree

  create_table "guestbooks", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.integer  "owner_id",    limit: 4,     null: false
    t.text     "description", limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guestbooks", ["name"], name: "index_guestbooks_on_name", unique: true, using: :btree
  add_index "guestbooks", ["owner_id"], name: "index_guestbooks_on_owner_id", using: :btree

  create_table "identities", force: :cascade do |t|
    t.string "provider", limit: 15,  null: false
    t.string "uid",      limit: 255, null: false
    t.string "nickname", limit: 50
  end

  add_index "identities", ["provider", "uid"], name: "index_identities_on_provider_and_uid", unique: true, using: :btree

  create_table "identity_followerships", force: :cascade do |t|
    t.string "uid",          limit: 255, null: false
    t.string "follower_uid", limit: 255, null: false
  end

  add_index "identity_followerships", ["uid", "follower_uid"], name: "index_identity_followerships_on_uid_and_follower_uid", unique: true, using: :btree

  create_table "inboxes", force: :cascade do |t|
    t.integer  "group_id",   limit: 4
    t.integer  "user_id",    limit: 4,     default: 0
    t.integer  "article_id", limit: 4
    t.integer  "score",      limit: 4,     default: 0
    t.boolean  "read",                     default: false
    t.binary   "post_ids",   limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "inboxes", ["group_id", "user_id", "article_id"], name: "index_inboxes_on_group_id_and_user_id_and_article_id", unique: true, using: :btree
  add_index "inboxes", ["read", "score"], name: "index_inboxes_on_read_and_score", using: :btree

  create_table "invitation_codes", force: :cascade do |t|
    t.string   "code",         limit: 255, null: false
    t.integer  "applicant_id", limit: 4,   null: false
    t.integer  "consumer_id",  limit: 4
    t.datetime "created_at"
    t.datetime "consumed_at"
    t.datetime "updated_at"
  end

  add_index "invitation_codes", ["applicant_id"], name: "index_invitation_codes_on_applicant_id", using: :btree
  add_index "invitation_codes", ["code"], name: "index_invitation_codes_on_code", unique: true, using: :btree

  create_table "likes", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "story_id",   limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "likes", ["story_id", "user_id"], name: "index_likes_on_story_id_and_user_id", unique: true, using: :btree

  create_table "list_items", force: :cascade do |t|
    t.integer  "article_id", limit: 4,               null: false
    t.integer  "list_id",    limit: 4,               null: false
    t.integer  "position",   limit: 4,   default: 0, null: false
    t.string   "notes",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", force: :cascade do |t|
    t.string   "name",       limit: 255,                   null: false
    t.integer  "user_id",    limit: 4,                     null: false
    t.boolean  "private",                  default: false, null: false
    t.text     "notes",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "group_id",   limit: 4
    t.string   "role",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: :cascade do |t|
    t.integer  "owner_id",     limit: 4,                     null: false
    t.integer  "sender_id",    limit: 4,                     null: false
    t.integer  "recipient_id", limit: 4,                     null: false
    t.text     "content",      limit: 65535,                 null: false
    t.boolean  "read",                       default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id",    limit: 4
  end

  add_index "messages", ["owner_id", "sender_id", "read"], name: "owner_id", using: :btree
  add_index "messages", ["owner_id", "target_id"], name: "index_messages_on_owner_id_and_target_id", using: :btree

  create_table "name_logs", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at"
  end

  add_index "name_logs", ["user_id"], name: "index_name_logs_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.text     "content",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read",                       default: false, null: false
    t.string   "scope",        limit: 255
    t.string   "subject_type", limit: 255
    t.integer  "subject_id",   limit: 4
    t.integer  "count",        limit: 4,     default: 1
  end

  add_index "notifications", ["scope"], name: "index_notifications_on_scope", using: :btree
  add_index "notifications", ["subject_type", "subject_id"], name: "index_notifications_on_subject_type_and_subject_id", using: :btree
  add_index "notifications", ["user_id", "scope", "subject_type", "subject_id"], name: "key1", using: :btree
  add_index "notifications", ["user_id", "scope"], name: "scope", unique: true, using: :btree

  create_table "oauth_nonces", force: :cascade do |t|
    t.string   "nonce",      limit: 255
    t.integer  "timestamp",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_nonces", ["nonce", "timestamp"], name: "index_oauth_nonces_on_nonce_and_timestamp", unique: true, using: :btree

  create_table "oauth_tokens", force: :cascade do |t|
    t.integer  "user_id",               limit: 4
    t.string   "type",                  limit: 20
    t.integer  "client_application_id", limit: 4
    t.string   "token",                 limit: 20
    t.string   "secret",                limit: 40
    t.string   "callback_url",          limit: 255
    t.string   "verifier",              limit: 20
    t.datetime "authorized_at"
    t.datetime "invalidated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_tokens", ["token"], name: "index_oauth_tokens_on_token", unique: true, using: :btree

  create_table "persistence_tokens", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.string   "token",      limit: 255
    t.string   "agent",      limit: 255
    t.decimal  "ip",                     precision: 12, default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "persistence_tokens", ["token"], name: "index_persistence_tokens_on_token", unique: true, using: :btree
  add_index "persistence_tokens", ["updated_at"], name: "index_persistence_tokens_on_updated_at", using: :btree
  add_index "persistence_tokens", ["user_id"], name: "index_persistence_tokens_on_user_id", using: :btree

  create_table "post_reposts", force: :cascade do |t|
    t.integer "original_group_id",   limit: 4
    t.integer "original_article_id", limit: 4
    t.integer "original_id",         limit: 4
    t.integer "group_id",            limit: 4
    t.integer "article_id",          limit: 4
    t.integer "repost_id",           limit: 4
    t.integer "sharer_id",           limit: 4
  end

  add_index "post_reposts", ["original_id", "group_id"], name: "key", unique: true, using: :btree
  add_index "post_reposts", ["original_id"], name: "index_post_reposts_on_original_id", using: :btree
  add_index "post_reposts", ["repost_id"], name: "index_post_reposts_on_repost_id", using: :btree
  add_index "post_reposts", ["sharer_id"], name: "index_post_reposts_on_sharer_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.text     "content",        limit: 65535,                 null: false
    t.integer  "user_id",        limit: 4,     default: 0,     null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "parent_id",      limit: 4
    t.integer  "ip",             limit: 4,     default: 0,     null: false
    t.integer  "group_id",       limit: 4
    t.integer  "topic_id",       limit: 4,     default: 0,     null: false
    t.integer  "floor",          limit: 4
    t.integer  "neg",            limit: 4,     default: 0,     null: false
    t.integer  "pos",            limit: 4,     default: 0,     null: false
    t.integer  "score",          limit: 4,     default: 0,     null: false
    t.boolean  "anonymous",                    default: false, null: false
    t.string   "status",         limit: 255,   default: "",    null: false
    t.string   "ancestry",       limit: 255,   default: "",    null: false
    t.integer  "ancestry_depth", limit: 4,     default: 0,     null: false
    t.integer  "parent_floor",   limit: 4
    t.string   "mentioned",      limit: 255
  end

  add_index "posts", ["ancestry"], name: "index_posts_on_ancestry", using: :btree
  add_index "posts", ["group_id", "topic_id", "floor"], name: "pk", unique: true, using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_reshare_and_parent_id", using: :btree
  add_index "posts", ["topic_id", "floor"], name: "article_id", unique: true, using: :btree

  create_table "preferences", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "owner_id",   limit: 4,   null: false
    t.string   "owner_type", limit: 255, null: false
    t.integer  "group_id",   limit: 4
    t.string   "group_type", limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_id", "owner_type", "name", "group_id", "group_type"], name: "index_preferences_on_owner_and_name_and_preference", unique: true, using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.text    "value",   limit: 65535
  end

  create_table "quest_logs", force: :cascade do |t|
    t.string  "quest_id", limit: 255,                      null: false
    t.integer "user_id",  limit: 4,                        null: false
    t.string  "status",   limit: 12,  default: "accepted"
  end

  create_table "queue", force: :cascade do |t|
  end

  create_table "ratings", force: :cascade do |t|
    t.string   "post_id",    limit: 24, default: "0", null: false
    t.integer  "user_id",    limit: 4,  default: 0,   null: false
    t.integer  "score",      limit: 4,  default: 0,   null: false
    t.datetime "created_at",                          null: false
  end

  add_index "ratings", ["created_at"], name: "created_at", using: :btree
  add_index "ratings", ["post_id", "user_id"], name: "index_ratings_on_article_id_and_user_id", unique: true, using: :btree
  add_index "ratings", ["score"], name: "index_ratings_on_score", using: :btree

  create_table "read_statuses", force: :cascade do |t|
    t.integer  "user_id",  limit: 4,             null: false
    t.integer  "group_id", limit: 4
    t.integer  "topic_id", limit: 4,             null: false
    t.integer  "read_to",  limit: 4, default: 0
    t.datetime "read_at"
    t.integer  "updates",  limit: 4, default: 0
  end

  add_index "read_statuses", ["user_id", "group_id", "topic_id", "read_to"], name: "total_index", using: :btree
  add_index "read_statuses", ["user_id", "group_id", "topic_id"], name: "alter_pk", unique: true, using: :btree

  create_table "references", force: :cascade do |t|
    t.integer  "source_id",     limit: 4
    t.integer  "target_id",     limit: 4
    t.string   "relation_type", limit: 255
    t.boolean  "detected"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "reports", force: :cascade do |t|
    t.string   "target_type",  limit: 255
    t.integer  "target_id",    limit: 4
    t.text     "info",         limit: 65535
    t.integer  "report_times", limit: 4
    t.integer  "operator_id",  limit: 4
    t.string   "result",       limit: 255
    t.datetime "operated_at"
  end

  create_table "reputation_logs", force: :cascade do |t|
    t.integer  "reputation_id", limit: 4
    t.integer  "user_id",       limit: 4
    t.integer  "group_id",      limit: 4
    t.string   "post_id",       limit: 24,  default: "0", null: false
    t.integer  "amount",        limit: 4
    t.string   "reason",        limit: 255
    t.date     "created_on"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "reputation_logs", ["created_on"], name: "index_reputation_logs_on_created_on", using: :btree
  add_index "reputation_logs", ["group_id", "user_id"], name: "index_reputation_logs_on_group_id_and_user_id", using: :btree
  add_index "reputation_logs", ["post_id"], name: "index_reputation_logs_on_post_id", using: :btree
  add_index "reputation_logs", ["reputation_id"], name: "index_reputation_logs_on_reputation_id", using: :btree

  create_table "reputations", force: :cascade do |t|
    t.integer "user_id",  limit: 4
    t.integer "group_id", limit: 4
    t.integer "value",    limit: 4,   default: 0
    t.string  "state",    limit: 255, default: "neutral"
    t.boolean "hide",                 default: false
  end

  add_index "reputations", ["group_id", "user_id"], name: "index_reputations_on_group_id_and_user_id", unique: true, using: :btree

  create_table "rewards", force: :cascade do |t|
    t.integer  "rewarder_id", limit: 4,                  null: false
    t.string   "post_id",     limit: 24
    t.integer  "winner_id",   limit: 4,                  null: false
    t.integer  "amount",      limit: 4
    t.boolean  "anonymous",              default: false
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "rewards", ["rewarder_id", "post_id"], name: "index_rewards_on_rewarder_id_and_post_id", unique: true, using: :btree

  create_table "roles", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id", limit: 4
    t.integer "user_id", limit: 4
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true, using: :btree

  create_table "salaries", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "amount",     limit: 4
    t.string   "type",       limit: 255
    t.date     "created_on"
    t.integer  "status",     limit: 4,   default: 0, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "salaries", ["type", "created_on"], name: "salary", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string "key",   limit: 255,   null: false
    t.text   "value", limit: 65535, null: false
  end

  add_index "settings", ["key"], name: "index_settings_on_key", unique: true, using: :btree

  create_table "simple_captcha_data", force: :cascade do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "sites", force: :cascade do |t|
    t.string   "name",       limit: 255,              null: false
    t.string   "domain",     limit: 255, default: "", null: false
    t.string   "alias",      limit: 255, default: "", null: false
    t.integer  "owner_id",   limit: 4,                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sites", ["domain"], name: "index_sites_on_domain", unique: true, using: :btree
  add_index "sites", ["owner_id"], name: "index_sites_on_owner_id", using: :btree

  create_table "slugs", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.integer  "sluggable_id",   limit: 4
    t.integer  "sequence",       limit: 4,   default: 1, null: false
    t.string   "sluggable_type", limit: 40
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], name: "index_slugs_on_n_s_s_and_s", unique: true, using: :btree
  add_index "slugs", ["sluggable_id"], name: "index_slugs_on_sluggable_id", using: :btree

  create_table "statuses", force: :cascade do |t|
    t.string   "content",    limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "statuses", ["user_id"], name: "index_statuses_on_user_id", using: :btree

  create_table "stories", force: :cascade do |t|
    t.integer  "guestbook_id", limit: 4
    t.integer  "author_id",    limit: 4
    t.text     "content",      limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes_count",  limit: 4,     default: 0,     null: false
    t.string   "picture",      limit: 255
    t.boolean  "anonymous",                  default: false, null: false
    t.string   "email",        limit: 64
  end

  add_index "stories", ["email"], name: "index_stories_on_email", using: :btree
  add_index "stories", ["guestbook_id", "author_id"], name: "index_stories_on_guestbook_id_and_author_id", using: :btree

  create_table "story_comments", force: :cascade do |t|
    t.integer  "story_id",   limit: 4,     null: false
    t.integer  "author_id",  limit: 4,     null: false
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "story_comments", ["story_id", "author_id"], name: "index_story_comments_on_story_id_and_author_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "subscriber_id",    limit: 4
    t.integer  "publication_id",   limit: 4
    t.string   "publication_type", limit: 32
    t.datetime "viewed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unread_count",     limit: 4,  default: 0, null: false
  end

  add_index "subscriptions", ["subscriber_id", "publication_id", "publication_type"], name: "index_subscriptions_on_subscriber_id_and_article_id", unique: true, using: :btree
  add_index "subscriptions", ["updated_at"], name: "index_subscriptions_on_updated_at", using: :btree
  add_index "subscriptions", ["viewed_at"], name: "index_subscriptions_on_viewed_at", using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 255
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "ticket_types", force: :cascade do |t|
    t.string  "name",        limit: 255,             null: false
    t.string  "description", limit: 255
    t.integer "weight",      limit: 4,   default: 0, null: false
    t.boolean "need_reason"
    t.string  "callback",    limit: 255
  end

  create_table "tickets", force: :cascade do |t|
    t.integer  "user_id",        limit: 4, null: false
    t.integer  "topic_id",       limit: 4, null: false
    t.integer  "ticket_type_id", limit: 4
    t.boolean  "correct"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "viewed_at"
  end

  add_index "tickets", ["topic_id"], name: "article_id", using: :btree
  add_index "tickets", ["user_id", "topic_id", "ticket_type_id", "correct"], name: "full_idx", using: :btree
  add_index "tickets", ["user_id", "topic_id"], name: "index_tickets_on_user_id_and_topic_id", unique: true, using: :btree

  create_table "topics", force: :cascade do |t|
    t.string   "tag_line",       limit: 255
    t.integer  "user_id",        limit: 4,   default: 0,         null: false
    t.datetime "created_at"
    t.string   "status",         limit: 7,   default: "pending", null: false
    t.integer  "group_id",       limit: 4,   default: 0,         null: false
    t.string   "comment_status", limit: 15,  default: "open",    null: false
    t.boolean  "anonymous",                  default: false,     null: false
    t.datetime "updated_at"
    t.string   "title",          limit: 255
    t.integer  "top_post_id",    limit: 4
    t.integer  "score",          limit: 4,   default: 0
    t.integer  "posts_count",    limit: 4,   default: 0
    t.integer  "views",          limit: 4,   default: 0,         null: false
  end

  add_index "topics", ["group_id", "status", "created_at"], name: "created_at", using: :btree
  add_index "topics", ["group_id", "status", "updated_at"], name: "index_topics_on_group_id_and_status_and_updated_at", using: :btree
  add_index "topics", ["status", "group_id", "id"], name: "status", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.integer  "balance_id", limit: 4,               null: false
    t.integer  "amount",     limit: 4,   default: 0, null: false
    t.string   "reason",     limit: 255
    t.datetime "created_at"
    t.string   "deal_type",  limit: 255
    t.integer  "deal_id",    limit: 4
  end

  add_index "transactions", ["balance_id", "created_at"], name: "index_transactions_on_balance_id_and_created_at", using: :btree
  add_index "transactions", ["deal_type", "deal_id"], name: "index_transactions_on_deal_type_and_deal_id", using: :btree

  create_table "user_profiles", force: :cascade do |t|
    t.integer "user_id",                         limit: 4,                  null: false
    t.string  "sex",                             limit: 255, default: ""
    t.date    "birthday"
    t.string  "hometown",                        limit: 255
    t.string  "bio",                             limit: 255
    t.boolean "want_receive_notification_email",             default: true, null: false
  end

  add_index "user_profiles", ["user_id"], name: "index_user_profiles_on_user_id", unique: true, using: :btree

  create_table "user_stats", force: :cascade do |t|
    t.integer "user_id",            limit: 4,             null: false
    t.integer "anonymous_comments", limit: 4, default: 0, null: false
    t.integer "public_comments",    limit: 4, default: 0, null: false
    t.integer "public_sofas",       limit: 4, default: 0, null: false
    t.integer "public_articles",    limit: 4, default: 0, null: false
    t.integer "anonymous_articles", limit: 4, default: 0, null: false
  end

  create_table "user_tokens", force: :cascade do |t|
    t.string   "provider",     limit: 20
    t.datetime "expires_at"
    t.string   "access_token", limit: 255
    t.string   "secret",       limit: 255
    t.string   "uid",          limit: 255
    t.string   "nickname",     limit: 50
    t.integer  "identity_id",  limit: 4
    t.integer  "user_id",      limit: 4,   null: false
  end

  add_index "user_tokens", ["provider", "uid"], name: "index_user_tokens_on_provider_and_uid", using: :btree
  add_index "user_tokens", ["user_id", "provider"], name: "index_user_tokens_on_user_id_and_provider", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "login",                     limit: 255,                     null: false
    t.string   "email",                     limit: 255,                     null: false
    t.string   "crypted_password",          limit: 255,                     null: false
    t.string   "salt",                      limit: 255,                     null: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "remember_token",            limit: 255, default: "",        null: false
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.string   "avatar_file_name",          limit: 255
    t.string   "avatar_content_type",       limit: 255
    t.integer  "avatar_file_size",          limit: 4
    t.datetime "avatar_updated_at"
    t.string   "state",                     limit: 255, default: "passive"
    t.datetime "deleted_at"
    t.string   "name",                      limit: 100
    t.string   "persistence_token",         limit: 255,                     null: false
    t.integer  "login_count",               limit: 4,   default: 0
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "last_request_at"
    t.string   "current_login_ip",          limit: 255
    t.string   "last_login_ip",             limit: 255
    t.string   "perishable_token",          limit: 255, default: "",        null: false
    t.string   "avatar_fingerprint",        limit: 255
  end

  add_index "users", ["email"], name: "email", unique: true, using: :btree
  add_index "users", ["login"], name: "login", unique: true, using: :btree
  add_index "users", ["perishable_token"], name: "index_users_on_perishable_token", using: :btree
  add_index "users", ["remember_token"], name: "remember_token", using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree

end
