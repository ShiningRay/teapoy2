# coding: utf-8
module User::ReadStatusAspect
  extend ActiveSupport::Concern

  included do
    has_many :read_statuses
  end

  def read_status_cache
    @read_status_cache ||= {}
  end

  # Public check if user has read some topic
  #
  # @params topic [Topic, Fixnum]- Topic to check
  #
  # Return a Integer stands for the max post floor id which user has already read
  def has_read_topic?(topic)
    if topic.is_a?(Fixnum)
      topic= Topic.find(topic)
    end
    aid = topic.id
    read_status_cache[aid] ||= read_statuses.where(:topic_id => aid).select(:read_to).first.try(:read_to)
  end

  # Public: check if user has truly read some topic.
  # It means that the user didn't click "dismiss" or "mark as read"
  #
  # topic - the Topic to check
  #
  # Return a Boolean true or false
  def has_truly_read_topic?(topic)
    r = has_read_topic?(topic)
    r && r.to_i >= 0
  end

  # Public: check if user has only glanced some topic.
  # It means that the user "dismiss" or "mark as read"
  #
  # topic - the Topic to check
  #
  # Return a Boolean true or false
  def has_glanced_topic?(topic)
    has_read_topic?(topic).to_i < 0
  end

  # Public: check if user has only glanced some topic.
  # It means that the user "dismiss" or "mark as read"
  #
  # topic - the Topic to check
  #
  # Return a Boolean true or false
  def has_read_post?(post)
    post = Post.wrap(post)
    return false unless post.floor
    aid = post.topic_id
    read_status_cache[aid] ||= has_read_topic?(aid)
    read_status_cache[aid] && read_status_cache[aid] >= post.floor
  end

  # Public: Update the user's read status
  #
  # topic - the Topic to read
  # floor   - Integer stands for which floor read to
  #
  # Return nothing
  def mark_read(topic, floor=nil)
    floor ||= topic.posts.size - 1
    return unless topic.is_a?(Topic)
    s = ReadStatus.find_or_create_by(user_id: id, topic_id: topic.id)
    s.read_to = floor if floor > s.read_to
    s.save!
  end

  def mark_topic_as_read(topic, floor=0)
    aid = topic
    topic = Topic.find(topic) unless topic.is_a?(Topic)
    return Rails.logger.info { "Cannot find topic #{aid}" } unless topic
    mark_read(topic, floor)
    notifications.by_scope(:reply).by_subject(topic).read!
    Inbox.where(:user_id => id, :topic_id => topic.id).read!
  end

  def mark_group_as_read(group)
    subscription_of(group).try(:mark_as_read!)
  end

  def bulk_mark_read(topic_ids)
    return if topic_ids.blank?
    topic_ids.each do |i|
      read_statuses[id] = 0 unless read_statuses[id]
    end
  end

  # Public: batch load read_status for topics
  #
  # topic - Array for Topic / Post to check
  #
  # Return an Array for read status
  def has_read?(*topics)
    topics.flatten!
    topics.compact!

    raise ArgumentError.new('need arguments') if topics.size == 0
    topic = topics.first

    return topic.is_a?(Post) ? has_read_post?(topic) : has_read_topic?(topic) if topics.size == 1

    if topic.is_a?(Post)
      posts = topics
      aids = post.collect { |p| p.topic_id }.uniq
      s = has_read_topic?(aids)
      return Hash[post.collect { |p| [p.id, has_read_post?(p)] }]
    end

    if topic.is_a?(Topic)
      ids = topics.map { |e| e.id }
    else
      ids = topics
    end

    read_statuses.where(:topic_id => ids).select(%w(topic_id read_to)).each do |i|
      read_status_cache[i.topic_id] = i.read_to
    end
    #read_status_cache.merge! bulk_get(ids)
    if topic.is_a?(Topic)
      topics.each do |o|
        read_status_cache[o.id]=false unless read_status_cache.include?(o.id)
      end
    else
      topics.each do |o|
        read_status_cache[o]=false unless read_status_cache.include?(o)
      end
    end
    return read_status_cache
  end
end
