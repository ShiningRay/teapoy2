# coding: utf-8
require 'rails_helper'

describe TopicsHelper do
  describe '#embed_topic', broken: true do
    let(:group) { create :group }
    let(:user){ create :user }
    it 'should show topic' do
      topic = Topic.new( :group_id => group.id,
                       :title => 'test',
                       :top_post_attributes => {
                           :content => '@test'})
      topic.status = 'publish'
      topic.save(:validate => false)
      # $stderr << topic.inspect
      # $stderr << group.inspect
      content = helper.embed_topic(topic.group.alias, topic.slug)
      expect(content).to eq(topic.content)
    end
  end
end
