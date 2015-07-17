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
#  last_posted_at :datetime         not null
#  last_poster_id :integer
#
# Indexes
#
#  created_at                                          (group_id,status,created_at)
#  index_topics_on_group_id_and_status_and_updated_at  (group_id,status,updated_at)
#  index_topics_on_last_posted_at                      (last_posted_at)
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

  describe 'LastPostAspect' do
    let(:user) { create :active_user }
    let(:topic) { create :topic_with_posts }
    it 'sets last poster after created new post' do
      p = topic.posts.create content: 'testing'
      topic.reload
      p.reload
      expect(topic.last_poster_id).to eq(p.user_id)
      expect(topic.last_posted_at).to eq(p.created_at)
    end

    it 'resets last poster after remove post' do

      topic.posts.last.destroy
      topic.reload
      p = topic.posts.last
      expect(topic.last_posted_at).to eq(p.created_at)
      expect(topic.last_poster_id).to eq(p.user_id)
    end
  end
end
