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
js
  end
end