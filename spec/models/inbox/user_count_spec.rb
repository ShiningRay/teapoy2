require 'spec_helper'

describe Inbox::UserCount do
  describe '.create_or_inc' do
    it 'increments a non-exists user_id to count 1' do
      Inbox::UserCount.create_or_inc(1)
      Inbox::UserCount.where(user_id: 1).first.count.should == 1
      Inbox::UserCount.create_or_inc(1)
      Inbox::UserCount.where(user_id: 1).first.count.should == 2
    end
  end

  describe 'Inbox change' do
    let(:user){create :user}
    let(:group){create :group}
    let(:article){create :article, group_id: group.id}
    it 'should increment corresponding user counter cache after create' do
      Inbox::UserCount.where(user_id: user.id).should_not be_exists
      Inbox.create!(user_id: user.id, article_id: article.id, group_id: group.id)
      Inbox::UserCount.where(user_id: user.id).first.count.should == 1
    end
    it 'should increment corresponding user counter cache after create' do
      Inbox::UserCount.where(user_id: user.id).should_not be_exists
      Inbox.create!(user_id: user.id, article_id: article.id, group_id: group.id)
      Inbox::UserCount.where(user_id: user.id).first.count.should == 1
    end
    context "inbox entry already created" do
      let(:entry)do
      end
      it "decrements corresponding user counter cache after entry destroyed" do
        entry = Inbox.create!(user_id: user.id, article_id: article.id, group_id: group.id)
        Inbox::UserCount.where(user_id: user.id).first.count.should == 1
        entry.destroy
        Inbox::UserCount.where(user_id: user.id).first.count.should == 0
      end
    end
  end
end
