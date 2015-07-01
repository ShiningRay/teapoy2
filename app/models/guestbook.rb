class Guestbook < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :stories
  validates :name, :owner, presence: true
  validates :name, uniqueness: true

  def self.migrate_from_group(group_id)
    group = Group.wrap(group_id)
    book = Guestbook.create name: group.name, owner: (group.owner || User.wrap('shiningray'))

    group.public_topics.each do |topic|
      next unless topic.top_post
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
      if topic.top_post.is_a?(Picture) and topic.top_post.picture?
        s.remote_picture_url = topic.top_post.picture.original.url
      end
      s.save
      s.liker_ids = topic.top_post.ratings.map(&:user_id)
      topic.comments.each do |p|
        s.comments.create content: p.content, author: p.user, created_at: p.created_at, updated_at: p.updated_at
      end
    end
  end
end
