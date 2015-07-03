# coding: utf-8
require 'rails_helper'

describe Topic do
  let(:group) { create :group }
  subject(:topic) { create :topic, group: group }
  describe '.next_in_group .prev_in_group' do

    let!(:one) { create :topic, group: group, status: 'publish', created_at: 1.minute.ago }
    let!(:two) { create :topic, group: group, status: 'publish' }
    it "navigates to correct record" do
      #topic = Topic.find
      expect(one.next_in_group).to eq(two)
      expect(two.prev_in_group).to eq(one)
    end
  end

  describe 'StatusAspect' do
    subject(:topic) { create :topic, group: group, status: 'pending' }
    before {
      allow_any_instance_of(Topic).to receive(:check_after_publish)
      Topic.after_publish :check_after_publish
    }

    after {
      Topic.skip_callback :publish, :after, :check_after_publish
    }

    it 'publishs topic' do
      topic.publish!
      expect(topic.published?).to be true
    end

    it 'fires after_publish callback' do
      expect(topic).to receive(:check_after_publish)
      topic.publish!
    end
  end

  describe '#content' do
    its(:content) { should == topic.top_post.content }
  end
end
