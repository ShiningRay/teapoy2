require 'rails_helper'

describe User do
  let(:user){create :user}
  let(:topic){create :topic}
  let(:article2){create :topic}

  context "haven't read any topic yet" do
    it " not has_read any topic" do
      expect(user.has_read_topic?(topic)).to be_falsey
    end
    it " not has_read any topic" do
      res = user.has_read?(topic, article2)
      expect(res).to include(topic.id)
      expect(res).to include(article2.id)
      expect(res[topic.id]).to be_falsey
      expect(res[article2.id]).to be_falsey
    end
  end
  context "have read the topic before" do
    before{ user.mark_read(topic) }
    it " return true" do
      expect(user.has_read_topic?(topic)).to be_truthy
    end
    it " return true" do
      res = user.has_read?(topic, article2)
      expect(res).to include(topic.id)
      expect(res).to include(article2.id)
      expect(res[topic.id]).to be_truthy
      expect(res[article2.id]).to be_falsey
    end
  end
end
