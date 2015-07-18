require 'rails_helper'

describe Topic::TopPostAspect do
  let(:group) { create :group }
  let(:author){ create :user }
  describe '.top_post' do
    it 'auto creates top_post' do
      expect{
        Topic.create title: 'title', content: 'content', user: author, group: group
      }.to change(Post, :count)
    end
  end
end