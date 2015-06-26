class Story < ActiveRecord::Base
  belongs_to :guestbook
  belongs_to :author, class_name: 'User'
  has_many :comments
  validates :guestbook, :author, :body, presence: true


  def self.migrate_from_group(group_id)
    group = Group.wrap(group_id)
    group.public_articles.each do |article|
      s = Story.new
      s.author = article.user
      s.content = ''
      if article.title.present?
        s.content = article.title
        s.content << "\n"
      end
      s.content << article.content
    end
  end
end
