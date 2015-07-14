# coding: utf-8
module Post::RepostAspect
  extend ActiveSupport::Concern
  included do
    # field :repost_indexes, type: Hash
    #has_many :repost_indexes, class_name: 'Repost::Index', foreign_key: :original_id
    # has_and_belongs_to_many :reposts, index: true
  end



  def repost_to sharer, group_id, anonymous = false, title = nil
    Rails.cache.delete([self, 'reposts_count'])
    sharer = User.wrap(sharer)
    sharer_id = sharer.id

    repost = Repost.new group_id: group_id,
                        original_id: id,
                        content: content,
                        anonymous: self.anonymous

    repost.floor = 0
    repost.user_id = user_id
    title = nil if title.blank?
    #group_ids.map do |gid|
    art= Topic.new  group_id: group_id,
                      title: title || "Repost",
                      anonymous: anonymous

    art.user_id = sharer_id
    art.top_post = repost
    art.publish! unless art.group.options.topics_need_approval
    art.save!
    #art.top_post.save!
    #reposted_to[group_id] = sharer_id
    save!
    art
    #end
  end

  def reposted_to?(group)
    Repost.where(:'index.original_id' => id, :'index.group_id' => Group.wrap(group).id).exists?
  end

  def reposted_topics
    Repost.where(:'index.original_id' => id).order_by(:id =>  'asc')
  end

  def reposted_topics_with_self
    arts = reposted_topics.to_a
    arts.unshift topic
    arts
  end

  def reposted_group_topics
    art = {}
    repost_indexes.each do |index|
      art[index.group] = index.topic
    end
    art
  end

  def reposted_group_topics_with_self
    art = reposted_topics
    art[group] = topic
    art
  end


  def has_repost?
    reposts.exists?
  end
end
