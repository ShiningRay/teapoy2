class ArticlePolicy < GroupPolicy
  attr_reader :article
  def initialize(user, record)
    @article = record
    super(user, @article.group)
  end

  def index?

  end

  def show?
    admin? || super && case
    when article.published?
      article_author? || super
    when article.pending?
      article_author? || group_owner?
    when article.draft?
      article_author?
    end
  end

  def create?
    member? and group.options
  end

  def update?

  end

  def destroy?

  end

  def article_author?
    !anonymous? && user.id == article.user_id
  end
end
