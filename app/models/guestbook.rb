class Guestbook < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_many :stories
  validates :name, :owner, presence: true
  validates :name, uniqueness: true

  def self.migrate_from_group(group_id)
    group = Group.wrap(group_id)
    book = Guestbook.create name: group.name, owner: (group.owner || User.wrap('shiningray'))

    group.public_articles.each do |article|
      next unless article.top_post
      puts article.id
      puts article.title
      s = Story.new guestbook: book
      s.author = article.user
      s.content = ''
      if article.title.present?
        s.content = article.title
        s.content << "\n"
      end
      s.content << article.top_post.content
      s.created_at = article.created_at
      s.updated_at = article.updated_at
      s.save
      s.liker_ids = article.top_post.ratings.map(&:user_id)
      article.comments.each do |p|
        s.comments.create content: p.content, author: p.user, created_at: p.created_at, updated_at: p.updated_at
      end
    end
  end
end
