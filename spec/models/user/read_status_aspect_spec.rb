require 'rails_helper'

describe User do
  let(:user){create :user}
  let(:article){create :article}
  let(:article2){create :article}

  context "haven't read any article yet" do
    it " not has_read any article" do
      expect(user.has_read_article?(article)).to be_falsey
    end
    it " not has_read any article" do
      res = user.has_read?(article, article2)
      expect(res).to include(article.id)
      expect(res).to include(article2.id)
      expect(res[article.id]).to be_falsey
      expect(res[article2.id]).to be_falsey
    end
  end
  context "have read the article before" do
    before{ user.mark_read(article) }
    it " return true" do
      expect(user.has_read_article?(article)).to be_truthy
    end
    it " return true" do
      res = user.has_read?(article, article2)
      expect(res).to include(article.id)
      expect(res).to include(article2.id)
      expect(res[article.id]).to be_truthy
      expect(res[article2.id]).to be_falsey
    end
  end
end
