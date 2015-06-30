require 'rails_helper'

describe Inbox::UserCount do
  describe '.create_or_inc' do
    it 'increments a non-exists user_id to count 1' do
      Inbox::UserCount.create_or_inc(1)
      expect(Inbox::UserCount.count_for(1)).to eq(1)
      Inbox::UserCount.create_or_inc(1)
      expect(Inbox::UserCount.count_for(1)).to eq(2)
    end
  end

  describe 'Inbox change' do
    let(:user){create :user}
    let(:group){create :group}
    let(:topic){create :topic, group_id: group.id}
    it 'should increment corresponding user counter cache after create' do
      expect(Inbox::UserCount.where(user_id: user.id)).not_to be_exists
      Inbox.create!(user_id: user.id, topic_id: topic.id, group_id: group.id)
      expect(Inbox::UserCount.count_for(user.id)).to eq(1)
    end

    it 'should increment corresponding user counter cache after create' do
      expect(Inbox::UserCount.where(user_id: user.id)).not_to be_exists
      Inbox.create!(user_id: user.id, topic_id: topic.id, group_id: group.id)
      expect(Inbox::UserCount.where(user_id: user.id).first.count).to eq(1)
    end

    context 'inbox entry already created' do
      let(:entry) {}

      it 'decrements corresponding user counter cache after entry destroyed' do
        entry = Inbox.create!(user_id: user.id, topic_id: topic.id, group_id: group.id)
        expect(Inbox::UserCount.count_for(user.id)).to eq(1)

        expect {entry.destroy}.to  change{Inbox::UserCount.count_for(user.id)}.by(-1)
      end
    end
  end
end
