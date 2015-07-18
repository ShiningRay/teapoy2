namespace 'cleanup' do
  desc 'remove topics without group'
  task :topics => :environment do
    Topic.where(group_id: nil).update_all(group_id: 1)
    Topic.where('not exists(select * from groups where id=topics.group_id)').find_each do |topic|
      puts topic
      topic.destroy
    end
  end

  desc 'remove posts without topic'
  task :posts => :environment do
    Post.where(topic_id: nil).destroy_all
    Post.where('not exists(select * from topics where id=posts.topic_id)').find_each do |post|
      post.destroy
    end
  end

  desc 'remove ratings without posts'
  task :ratings => :environment do
    Rating.where('not exists(select * from posts where id=ratings.post_id)').delete_all
  end

  desc 'remove attachments without posts'
  task :attachments => :environment do
    # destroy because we need to remove files
    Attachment.where(post_id: nil).destroy_all
    Attachment.where('not exists(select * from posts where id=attachments.post_id)').find_each do |attachment|
      attachment.destroy
    end
  end
end