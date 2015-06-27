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
      s.save
      article.comments.each do |p|
        s.comments.create content: p.content, author: p.user
      end
    end
  end
end
