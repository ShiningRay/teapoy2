namespace 'cleanup' do
  desc 'remove topics without group'
  task :topics => :environment do
    Topic.where(group_id: nil).destroy_all
    Topic.where('not exists(group_id)').find_each do |topic|
      topic.destroy
    end
  end

  desc 'remove posts without topic'
  task :posts => :environment do
    Post.where(topic_id: nil).destroy_all
    Post.where('not exists(topic_id)').find_each do |post|
      post.destroy
    end
  end

  desc 'remove ratings without posts'
  task :ratings => :environment do

  end

  desc 'remove attachments without posts'
  task :attachments => :environment do
    # destroy because we need to remove files
    Attachment.where(post_id: nil).destroy_all
  end
end