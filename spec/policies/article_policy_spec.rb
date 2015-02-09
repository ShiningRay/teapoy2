describe ArticlePolicy do
  subject { ArticlePolicy }
  let(:user) { create :user }
  let(:admin) { create :user, admin: true }
  let(:article) { create :article }
  permissions :update? do
    it "does not allow guest access if article is unpublished" do
      expect(subject).not_to permit(user, article)
    end

    it "grants access if post is published and user is an admin" do
      expect(subject).to permit(User.new(:admin => true), Post.new(:published => true))
    end

    it "grants access if post is unpublished" do
      expect(subject).to permit(User.new(:admin => false), Post.new(:published => false))
    end
  end
end
