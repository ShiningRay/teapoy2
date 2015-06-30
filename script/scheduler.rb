#!/usr/bin/env ruby
require_relative  '../config/environment'
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.new

scheduler.every '60m', :blocking => true do
  t = Time.now
  Inbox.decay_score! unless t.hour >= 1 and t.hour <= 8
end

scheduler.every '5m', :blocking => true do
  Topic.update_scores
  Topic.schedule_future_articles
end

scheduler.join
