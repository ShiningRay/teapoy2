# coding: utf-8
# == Schema Information
#
# Table name: topics
#
#  id             :integer          not null, primary key
#  tag_line       :string(255)
#  user_id        :integer          default(0), not null
#  created_at     :datetime
#  status         :string(7)        default("pending"), not null
#  group_id       :integer          default(0), not null
#  comment_status :string(15)       default("open"), not null
#  anonymous      :boolean          default(FALSE), not null
#  updated_at     :datetime
#  title          :string(255)
#  top_post_id    :integer
#  score          :integer          default(0)
#  posts_count    :integer          default(0)
#  views          :integer          default(0), not null
#
# Indexes
#
#  created_at                                          (group_id,status,created_at)
#  index_topics_on_group_id_and_status_and_updated_at  (group_id,status,updated_at)
#  status                                              (status,group_id,id)
#

require 'rails_helper'

describe Topic do
  let(:group) { create :group }
  subject(:topic) { create :topic, group: group }
  describe '.next_in_group .prev_in_group' do

    let!(:one) { create :topic, group: group, status: 'publish', created_at: 1.hour.ago }
    let!(:two) { create :topic, group: group, status: 'publish' }
    it "navigates to correct record" do
      #topic = Topic.find
      # binding.pry
      expect(one.next_in_group).to eq(two)
      expect(two.prev_in_group).to eq(one)
    end
  end

  describe '.after' do
    before do
      @first = create :topic, group: group, created_at: 1.day.ago
      @second = create :topic, group: group, created_at: 1.hour.ago
      @third = create :topic, group: group, created_at: 1.minute.ago
    end
    it 'selects records after specified time' do
      expect(Topic.after(@second.created_at).first).to eq(@third)
    end
  end

  describe '.before' do
    before do
      @first = create :topic, group: group, created_at: 1.day.ago
      @second = create :topic, group: group, created_at: 1.hour.ago
      @third = create :topic, group: group, created_at: 1.minute.ago
    end

    it 'selects records before specified time' do
      expect(Topic.before(@second.created_at).first).to eq(@first)
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
