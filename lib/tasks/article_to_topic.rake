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
    db[:posts].find.update_all('$unset' => {"_type" => ""})
  end

  desc 'move picture field to attachment'
  task :move_picture_to_attachment => :environment do
    require 'qiniu'
    require 'concurrent/executors'

    qiniu = Rails.application.secrets.qiniu.with_indifferent_access
    Qiniu.establish_connection! :access_key => qiniu[:access_key],
                            :secret_key => qiniu[:secret_key]
    bucket = qiniu[:bucket]
    db = Mongoid::Sessions.default

    pool = Concurrent::ThreadPoolExecutor.new(
       min_threads: 15,
       max_threads: 15,
       max_queue: 100,
       fallback_policy: :caller_runs
    )

    Post.where(:picture_file_name.exists => true).each do |post|
      pool.post do
        puts "id: #{post.id} #{post.topic_id}"
        next unless post.picture?
        attachment = post.attachments.new content_type: post[:picture_content_type], dimensions: post[:dimensions], uploader_id: post.user_id

        attachment[:file] = post[:picture_file_name]

        code, result, response_headers = Qiniu::Storage.move(
          bucket, post.picture.path,
          bucket, attachment.file.path
        )

        attachment.save!
        content = "#{post.content}\n\n![#{post[:picture_file_name]}](#{attachment.file.url})"
        post.remove_picture!
        db[:posts].find('_id' => post.id).update('$set' => {picture_file_name: nil, content: content})
      end
    end
  end

  desc 'export groups'

  task :export_groups => :environment do
    db = Mongoid::Sessions.default
    conn = ActiveRecord::Base.connection
    db[:groups].find.each do |group|
      puts "insert into groups set id='#{group['_id']}', name=#{conn.quote group['name']},
      alias=#{conn.quote group['alias']}, description=#{conn.quote group['description']},
      owner_id='#{group['owner_id']}', icon_file_name=#{conn.quote group['icon_file_name']},
      icon_content_type=#{conn.quote group['icon_content_type']}, icon_updated_at=#{conn.quote group['icon_updated_at']},
      icon_file_size=#{group['icon_file_size']}, `private`=#{conn.quote group['private']},
      feature=#{conn.quote group['feature']}, theme=#{conn.quote group['theme']},
      status=#{conn.quote group['status']}, hide=#{conn.quote group['hide']},
      domain=#{conn.quote group['domain']}
      "
    end
  end
  desc 'export topics'
  task :export_topics => :environment do
    db = Mongoid::Sessions.default
    conn = ActiveRecord::Base.connection

    db[:topics].find.each do |topic|
      puts 'truncate topics;'
      puts "insert into topics set id='#{topic['_id']}', title=#{conn.quote topic['title']},
      user_id=#{topic['user_id']}, group_id=#{topic['group_id']}, created_at=#{conn.quote topic['created_at']},
      updated_at=#{conn.quote topic['updated_at']}, comment_status=#{conn.quote topic['comment_status']||'open'},
      anonymous=#{conn.quote topic['anonymous']}, tag_line=#{conn.quote topic['tag_line']},
      status=#{conn.quote topic['status']};"
    end
  end

  desc 'migrate post'
  task :export_posts => :environment do
    db = Mongoid::Sessions.default
    conn = ActiveRecord::Base.connection
    puts 'truncate posts;'
    # start = 0
    # loop do
    #   rows = conn.select_all("select * from topics where id > #{start} order by id asc limit 1000").each_entry do |topic|
    #     idmap = {}
    #     db[:posts].find(topic_id: id).sort(floor: 1).each do |post|
    #       puts <<-sql
    #       insert into posts set topic_id=#{conn.quote post['topic_id']},content=#{conn.quote post['content']},
    #       created_at=#{conn.quote post['created_at']}, updated_at=#{conn.quote post['updated_at']},
    #       user_id=#{conn.quote post['user_id']}, group_id=#{conn.quote post['group_id']},
    #       parent_floor=#{conn.quote post['parent_floor']}, floor=#{conn.quote post['floor']},
    #       anonymous=#{conn.quote post['anonymous'] || false}, mentioned=#{conn.quote post['mentioned'].join(',')},
    #       pos=#{conn.quote post['pos']}, neg=#{conn.quote post['neg']}, score=#{conn.quote post['score']},
    #       status=#{conn.quote post['status'] || ''}
    #
    #       sql
    #     end
    #   end
    # end
    db[:posts].find({topic_id: {'$ne' => nil}}).sort(:topic_id => 1, :floor => 1).each do |post|
      puts <<-sql
      insert into posts set topic_id=#{conn.quote post['topic_id']},content=#{conn.quote post['content']},
      created_at=#{conn.quote post['created_at']}, updated_at=#{conn.quote post['updated_at']||post['created_at']||Time.now},
      user_id=#{conn.quote post['user_id']}, group_id=#{conn.quote post['group_id']},
      parent_floor=#{conn.quote post['parent_floor']}, floor=#{conn.quote post['floor']},
      anonymous=#{conn.quote post['anonymous'] || false}, mentioned=#{conn.quote Array(post['mentioned']).join(',')},
      pos=#{conn.quote post['pos']}, neg=#{conn.quote post['neg']}, score=#{conn.quote post['score']},
      status=#{conn.quote post['status'] || ''}, ip=#{conn.quote post['ip']||0};
      set @id = last_insert_id();
      update ratings set post_id=@id where post_id=#{conn.quote post['_id'].to_s};
      update rewards set post_id=@id where post_id=#{conn.quote post['_id'].to_s};
      update attachments set post_id=@id where post_id=#{conn.quote post['_id'].to_s};
      sql
    end
  end

  desc 'migrate attachments'
  task :export_attachments => :environment do
    db = Mongoid::Sessions.default
    conn = ActiveRecord::Base.connection
    puts 'truncate attachments;'
    db[:attachments].find.each do |a|
      sql = <<-sql
      insert into attachments set post_id = #{conn.quote a['post_id'].to_s}, uploader_id = #{conn.quote a['uploader_id']||0}, file=#{conn.quote a['file']},
      sql
      if a['dimensions'] && a['dimensions']['original']
        d = a['dimensions']['original']
        sql << "width=#{d[0]||0}, height=#{d[1]||0},"
      end
      sql << "content_type=#{conn.quote a['content_type']}, file_size=#{conn.quote a['file_size']};"
      puts sql
    end
  end

  desc 'reassign parents'
  task reassign_posts_parent: :environment do
    conn = ActiveRecord::Base.connection
    start = 0
    loop do
      res = conn.select_all("select id, topic_id, parent_floor, floor from posts where id > #{start} and parent_id is null and floor is not null limit 1000")
      break if res.length == 0
      res.each_entry do |post|
        puts "#{post['topic_id']} #{post['id']} #{post['floor']}"
        conn.execute "update posts set parent_id=#{post['id']} where topic_id=#{post['topic_id']} and parent_floor=#{post['floor']}"
        start = post['id']
      end
    end
  end

  desc 'reassign top_post_id'
  task reassign_top_post: :environment do
    conn = ActiveRecord::Base.connection
    start = 0
    loop do
      res = conn.select_all("select id, topic_id from posts where id > #{start} and floor = 0 order by id asc limit 1000")
      break if res.length == 0
      res.each_entry do |post|
        puts "#{post['topic_id']} -> #{post['id']}"
        conn.execute "update topics set top_post_id=#{post['id']} where id=#{post['topic_id']}"
        start = post['id']
      end
    end
  end

  desc 'update topic posts_count cache'
  task resync_posts_count: :environment do
    ActiveRecord::Base.connection.execute <<-sql
    update `topics` inner join (select topic_id, count(*) as cnt from posts group by topic_id) as counts on topics.id = counts.topic_id set topics.posts_count = counts.cnt;
    sql
  end

  desc 'migrate user profile'
  task :migrate_user_profiles => :environment do
    mongo = Mongoid::Sessions.default

    mongo[:user_profiles].find.each do |p|
      puts p.delete('_id')
      puts p['user_id']
      UserProfile.create! p
    end
  end
end