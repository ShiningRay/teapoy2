# == Schema Information
#
# Table name: rewards
#
#  id          :integer          not null, primary key
#  rewarder_id :integer          not null
#  post_id     :string(24)
#  winner_id   :integer          not null
#  amount      :integer
#  anonymous   :boolean          default(FALSE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

describe Reward do
  let(:author) { create :user }
  let(:post) { create(:post, user: author, article: create(:article), floor: 1, parent_id: 0) }
  before do
    author.gain_credit(100)
  end
  it "not be able to reward his own post" do
    r = Reward.make author, post, rand(10..100)
    r.should_not be_valid
  end
  context "given a user is not the author" do
    let(:user) { create :user }
    context "given his credit is enough" do
      before do
        user.gain_credit(100)
      end
      it "should be able to reward to the post" do
        r = Reward.make(user, post, 20)
        r.should be_valid
        user.balance.reload
        author.balance.reload
        expect(user.balance.credit).to eq(80)
        expect(author.balance.credit).to eq(120)
      end
      it "should not be able to reward zero" do
        r = Reward.make(user, post, 0)
        r.should_not be_valid
        user.balance.reload
        author.balance.reload
        expect(user.balance.credit).to eq(100)
        expect(author.balance.credit).to eq(100        )
      end
      it "should not be able to reward more than his credit" do
        expect{
          Reward.make(user, post, 120)
        }.to raise_error(Balance::InsufficientFunds)
        user.balance.reload
        author.balance.reload
        expect(user.balance.credit).to eq(100)
        expect(author.balance.credit).to eq(100)
      end
      it "should not be able to reward the post twice" do
        r = Reward.make(user, post, 10)
        r.should be_valid
        r = Reward.make(user, post, 10)
        r.should_not be_valid
      end
    end
  end
end
