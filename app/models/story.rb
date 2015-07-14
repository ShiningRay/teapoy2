class Story < ActiveRecord::Base
  belongs_to :guestbook
  belongs_to :author, class_name: 'User'
  has_many :comments, class_name: 'StoryComment', dependent: :delete_all
  has_many :likes, dependent: :delete_all
  has_many :likers, through: :likes, source: :user
  validates :guestbook, presence: true
  validates :content, presence: true, unless: 'picture?'
  validates :author, presence: true, if: -> { author_id? }
  # validates :email, presence: true, unless: -> { author_id? }

  scope :latest, -> { order(:id => :desc )}
  scope :anonymous, -> { where(anonymous: true) }
  scope :signed, -> { where(anonymous: false) }
  before_validation {
    self.anonymous = true unless author_id?
  }
  mount_uploader :picture, PictureUploader

  def self.migrate_from_topic(topic_id, guestbook_id, bucket)
    if topic_id.is_a?(Topic)
      topic = topic_id
      topic_id = topic.id
    else
      topic = Topic.find topic_id
    end

    if guestbook_id.is_a?(Guestbook)
      guestbook = guestbook_id
      guestbook_id = guestbook.id
    else
      guestbook = Guestbook.find guestbook_id
    end


    puts topic.id
    puts topic.title
    s = Story.new guestbook: guestbook
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
end
