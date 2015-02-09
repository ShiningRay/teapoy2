class PostPolicy < ArticlePolicy
  attr_reader :post
  def initialize(user, record)
    @post = record
    super(user, @post.article) if @post.article
  end

  def create?
    article.comment_status == 'open'
  end

  def update?
    false
  end

  def destroy?
    admin? || post_author? || article_author? || group_owner?
  end

  protected
  def post_author?
    user && user.id == post.user_id
  end
end
