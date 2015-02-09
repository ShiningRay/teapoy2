class ChangeLog
  include Mongoid::Document
  # attr_accessible :title, :body
  field :changed_values, type: Hash
  field :operator_id, type: Integer
  field :post_id, type: Integer
  def self.migrate
    id = 0
    Article.unscoped do
      loop do
        recs = Post.connection.select_all("select * from posts where `type` like 'ChangeLog' and id > #{id} order by id asc limit 2000")
        break if recs.size == 0
        recs.each do |rec|
          begin
          id = rec['id']
          puts id
          meta = MessagePack.unpack(rec['meta'])
          a = {}
          article = Article.find_by_id(rec['article_id'])
          post = article.posts.find_by_floor(rec['parent_id'])
          if post
            a[:changed_values] = meta['changed_fields']
            a[:post_id] = post.id
            a[:operator_id] = rec['user_id']
            a[:created_at] = rec['created_at']
            a[:updated_at] = rec['updated_at']
            log = ChangeLog.new a
            log.save!
            meta['described_type'] = 'ChangeLog'
            meta['described_id'] = log.id.to_s
            p meta
            Post.connection.execute("update posts set type='Post', meta=#{Post.sanitize meta.to_msgpack} where id=#{id}")
          else
            Post.connection.execute "delete from posts where id=#{id}"
          end
          rescue
            puts rec.id
            puts $!.message
            puts $!.backtrace.join("\n")
          end
        end
      end
    end
  end
end
