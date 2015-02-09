# coding: utf-8
class CreateSubscriptions < ActiveRecord::Migration
  def self.up
  create_table "subscriptions", :force => true do |t|
    t.integer  "subscriber_id"
    t.integer  "publication_id"
    t.string   "publication_type", :limit => 32
    t.datetime "viewed_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "unread_count",                   :default => 0, :null => false
  end

  add_index "subscriptions", ["subscriber_id", "publication_id", "publication_type"], :name => "index_subscriptions_on_subscriber_id_and_article_id", :unique => true
  add_index "subscriptions", ["updated_at"], :name => "index_subscriptions_on_updated_at"
  add_index "subscriptions", ["viewed_at"], :name => "index_subscriptions_on_viewed_at"
  end

  def self.down
    drop_table :subscriptions
  end
end
