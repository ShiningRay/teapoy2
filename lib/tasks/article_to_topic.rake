# assets file encoding check for ruby 1.9

namespace :migration do

  desc 'Rename articles to topics'
  task :article_to_topic => :environment do
    db = Mongoid::Sessions.default
    db[:posts].update({'$rename' => {'article_id' => 'topic_id'}})
    db[:inboxes].update({'$rename' => {'article_id' => 'topic_id'}})
<<js

  db.articles.renameCollection('topics');
  db.posts.dropIndex({"article_id" : 1, "floor" : 1 });
db.posts.update({}, {'$rename':{'article_id': 'topic_id'}}, {multi: true});
db.posts.ensureIndex({"topic_id" : 1, "floor" : 1 }, {background: true, unique: true});
db.inboxes.dropIndex({"user_id" : 1, "article_id" : -1 });
db.inboxes.dropIndex({"article_id" : 1 });
db.inboxes.update({}, {'$rename':{'article_id': 'topic_id'}}, {multi: true});
db.inboxes.ensureIndex({"user_id" : 1, "topic_id" : -1 });
db.inboxes.ensureIndex({"topic_id" : 1 });
db.notifications.update({subject_type: 'Article'}, {$set: {subject_type: 'Topic'}}, {multi: true});
db.sequences.update({seq_name: "article__id"}, {$set: {seq_name: 'topic__id'}});
js
  end

  desc 'Change Posts'
  task :post_degrade => :environment do
    db = Mongoid::Sessions.default
    db[:groups].find.update_all('$set' => {'theme' => ''})
    db[:posts].find('_type' => 'ExternalPage').each do |post|
      post['_type'] = 'Post'
      post['content'] << "\n源地址：#{post.delete(:source_link)}"
      db[:posts].find('_id' => post['_id']).update(post)
    end

    db[:posts].find('_type' => 'Picture').update_all('$set' => {'_type' => 'Post'})
    db[:posts].find('_type' => 'Album').remove_all
    db[:posts].find('_type' => 'Collection').remove_all
    db[:posts].find('_type' => 'Flash').remove_all
    db[:posts].find('_type' => 'ExternalVideo').remove_all
    db[:posts].find('_type' => 'Poll').each do |p|
      p['_type'] = 'Post'
      p['content'] = p.delete('question')
      p.delete(:voters)
      p.delete(:vote_count)
      p.delete(:max_selection)
      p.delete(:min_selection)
      db[:posts].find('_id' => post['_id']).update(post)
    end
    db[:posts].find('_type' => 'Vote').each do |p|
      p['_type'] = 'Post'
      p['content'] = p.delete('choice')
      db[:posts].find('_id' => post['_id']).update(post)
    end

  end
end