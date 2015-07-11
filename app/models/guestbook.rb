class Guestbook < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :stories, dependent: :destroy
  validates :name, :owner, presence: true
  validates :name, uniqueness: true

  def self.migrate_from_group(group_id)
    require 'qiniu'
    require 'concurrent/executors'

    qiniu = Rails.application.secrets.qiniu.with_indifferent_access
    Qiniu.establish_connection! :access_key => qiniu[:access_key],
                            :secret_key => qiniu[:secret_key]
    bucket = qiniu[:bucket]
    db = Mongoid::Sessions.default
    pool = Concurrent::ThreadPoolExecutor.new(
       min_threads: 15,
       max_threads: 25,
       max_queue: 100,
       fallback_policy: :caller_runs
    )
    group = Group.wrap(group_id)
    book = Guestbook.create name: group.name, owner: (group.owner || User.wrap('shiningray'))

    group.public_topics.each do |topic|
      next unless topic.top_post

      pool.post do
        puts topic.id
        puts topic.title
        s = Story.new guestbook: book
        s.author = topic.user
        s.content = ''

        if topic.title.present?
          s.content = topic.title
          s.content << "\n"
        end

        s.content << topic.top_post.content
        s.created_at = topic.created_at
        s.updated_at = topic.updated_at

        s.save!
        s.liker_ids = topic.top_post.ratings.map(&:user_id)

        if topic.top_post.picture?
          puts topic.top_post.picture.url
          p = s[:picture] = topic.top_post[:picture_file_name]
          i = s.id
          Qiniu.copy bucket, topic.top_post.picture.path, bucket, "uploads/story/picture/#{i}/#{p}"
          Qiniu.copy bucket, topic.top_post.picture.thumb.path, bucket, "uploads/story/picture/#{i}/thumb_#{p}"
          Qiniu.copy bucket, topic.top_post.picture.small.path, bucket, "uploads/story/picture/#{i}/small_#{p}"
          Qiniu.copy bucket, topic.top_post.picture.longsmall.path, bucket, "uploads/story/picture/#{i}/longsmall_#{p}"
          Qiniu.copy bucket, topic.top_post.picture.medium.path, bucket, "uploads/story/picture/#{i}/medium_#{p}"
          Qiniu.copy bucket, topic.top_post.picture.large.path, bucket, "uploads/story/picture/#{i}/large_#{p}"
        end

        topic.comments.each do |p|
          s.comments.create content: p.content, author: p.user, created_at: p.created_at, updated_at: p.updated_at
        end
      end
      pool.shutdown
      pool.wait_for_termination
    end
  end
end
