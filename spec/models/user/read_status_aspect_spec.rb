require 'spec_helper'

describe User do
  let(:user){create :user}
  let(:article){create :article, user: create(:user), group: create(:group)}
  let(:article2){create :article, user: create(:user), group: create(:group)}

  context "haven't read any article yet" do
    it "should not has_read any article" do
      user.has_read_article?(article).should be_false
    end
    it "should not has_read any article" do
      res = user.has_read?(article, article2)
      res.should include(article.id)
      res.should include(article2.id)
      res[article.id].should be_false
      res[article2.id].should be_false
    end
  end
  context "have read the article before" do
    before{ user.mark_read(article) }
    it "should return true" do
      user.has_read_article?(article).should be_true
    end
    it "should return true" do
      res = user.has_read?(article, article2)
      res.should include(article.id)
      res.should include(article2.id)
      res[article.id].should be_true
      res[article2.id].should be_false
    end
  end
end
