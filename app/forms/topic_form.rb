class TopicForm
  include ActiveModel::Model
  attr_accessor :title, :content, :picture, :anonymous, :uncommentable, :attachment_ids
  attr_accessor :topic, :user
  validates :title, :content, presence: true

  def initialize(user, topic=Topic.new)
    @topic = topic
    @user = user
    @topic.build_top_post unless @topic.top_post
    pull unless @topic.new_record?
  end

  def validate(params)
    @title = params[:title]
    @content = params[:content]
    @picture = params[:picture]
    @attachment_ids = params[:attachment_ids]
    # @comment_status ||= 'open'
    push
    @topic.valid?
  end

  # push data into model
  def push
    @topic.title = title.strip
    @topic.top_post.content = content.strip
    @topic.user = @user
    @topic.anonymous = anonymous
    @topic.group_id ||= 1
    @topic.status = 'publish'
    # @topic.uncommentable = uncommentable

    if picture
      attachment = Attachment.create uploader_id: @user.id, file: picture
      @topic.top_post.content << "![#{attachment[:file]}](#{attachment.file.url})"
      @attachment_ids = [attachment.id.to_s]
    end

  end

  # pull data from model
  def pull
    @title = @topic.title
    @content = @topic.top_post.content
    @attachment_ids = @topic.top_post.attachment_ids
  end

  def save
    push
    @topic.save
    @topic.top_post.attachment_ids = @attachment_ids unless @attachment_ids.blank?
    true
  end
end