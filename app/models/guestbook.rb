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
        Story.migrate_from_topic(topic, book)
      end
      pool.shutdown
      pool.wait_for_termination
    end
  end
end
