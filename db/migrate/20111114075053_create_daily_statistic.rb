# coding: utf-8
class CreateDailyStatistic < ActiveRecord::Migration
  def up
  create_table "daily_statistics", :force => true do |t|
    t.datetime "record_data"
    t.integer  "login_count"
  end
  end

  def down
    drop_table "daily_statistics"
  end
end
