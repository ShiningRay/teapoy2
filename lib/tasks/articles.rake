
namespace :topics do
  def fix_missing_article
    Topic.observers.disable(Topic::ChargeObserver)
    Post.where(floor: nil, parent_id: nil, article_id: nil).update(floor: 0)
    Post.where(article_id: nil).order_by(_id: :asc).each do |post|
      begin
      post.group_id ||= 1
      post.parent_ids ||= []
      post.save

      if post.parent_id.blank?
        post.floor ||= 0
        article = post.create_article(user_id: post.user_id,
          score: post.score,
          created_at: post.created_at,
          anonymous: post.anonymous,
          group_id: post.group_id,
          top_post_id: post.id,
          posts_count: 1)
        post.article_id = article.id
      else
        if post.parent
          post.article_id = post.parent.article_id
          post.group_id = post.parent.group_id
          post.parent.parent_ids ||= []
          post.save
        else
          post.parent_id = nil
          post.parent_ids = []
          post.floor = 0
          article = post.create_article(user_id: post.user_id,
            score: post.score,
            created_at: post.created_at,
            anonymous: post.anonymous,
            group_id: post.group_id,
            top_post_id: post.id)

          post.article_id = article.id
        end
      end
      post.save
      rescue
        Post.collection.find({_id: post.id}).remove
      end
    end
  end

  def remove_deleted
    Post.unscoped.where(:status.in => %w(deleted spam)).each do |post|
      Post.collection.find({:'$or' => [{:_id => post.id}, {:parent_id => post.id}, {:parent_ids => post.id}]}).remove_all
    end
  end

  def fix_missing_floor
    Post.where(:article_id.ne => nil, :floor => nil).each do |post|
      begin
        puts post.inspect
        article = post.topic
        if post.id == article.top_post_id
          post.parent_id = nil
          post.parent_ids = []
          post.floor = 0
        else
          if post.parent_id.blank? or post.parent.blank?
            post.parent_floor = 0
            post.parent_id = article.top_post_id
            post.parent_ids = [article.top_post_id]
          end
          post.number_floor
        end
        post.save
        puts post.errors.inspect
      rescue
        Post.collection.find({_id: post.id}).remove
      end
    end
  end
end
