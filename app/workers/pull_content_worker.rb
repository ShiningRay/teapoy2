#!/usr/bin/env ruby
# coding: utf-8
class PullContentWorker
  include Sidekiq::Worker
  def perform(subscription_id)
    subscription = Subscription.find_by_id subscription_id
    return Rails.logger.info('cannot find subscription') unless subscription

    return unless subscription.publication.is_a?(Group) or subscription.publication.is_a?(User)
    hottest = subscription.publication.topics.hottest.limit(10).to_a
    latest = subscription.publication.topics.latest.limit(10).to_a
    articles = (hottest + latest).uniq
    articles.each do |a|
      Inbox.delay.deliver(subscription.subscriber_id, a.top_post.id) if a.top_post
    end
  end
end
