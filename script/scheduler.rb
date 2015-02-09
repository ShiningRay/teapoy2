#!/usr/bin/env ruby
require_relative  '../config/environment'
require 'rufus/scheduler'
require 'daemons'
options = {
  :backtrace  => true,
  :log_output => true,
  :dir_mode   => :normal,
  :dir        => Rails.root.join('tmp/pids'),
  :log_dir    => Rails.root.join('log'),
  :monitor    => true
}

Daemons.run_proc 'scheduler', options do
  scheduler = Rufus::Scheduler.new

  scheduler.every '60m', :blocking => true do
    t = Time.now
    Inbox.decay_score! unless t.hour >= 1 and t.hour <= 8
  end

  scheduler.every '5m', :blocking => true do
    Article.update_scores
    Article.schedule_future_articles
  end

  scheduler.join
end
