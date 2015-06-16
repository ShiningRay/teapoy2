require 'rails_helper'
describe ArticlePolicy do
  subject { described_class }
  let(:user) { create :user }
  let(:admin) { create :admin }
  let(:author) { create :user }
  let(:public_article) { create :article, user: author, status: 'publish' }
  let(:pending_article) { create :article, user: author, status: 'pending' }

  permissions :update? do
    it "does not allow guest access if article is unpublished" do
      expect(subject).not_to permit(user, pending_article)
    end

    it "not grants access if post is published and user is an normal user" do
      expect(subject).not_to permit(user, public_article)
    end

    it "grants access if post is unpublished and user is an admin" do
      expect(subject).to permit(admin, pending_article)
    end

    it "grants access if post is unpublished and user is an author" do
      expect(subject).to permit(author, public_article)
    end
  end
end
