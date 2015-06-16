require 'rails_helper'

describe User::RewardAspect do
  describe 'send reward' do
  end
  let(:user){ create :user }
  describe '#total_winned_rewards' do
    before { create :reward, winner: user, amount: 10 }
    it "calcs all the rewards user winned" do
      expect(user.total_winned_rewards).to eq(10)
    end
  end
end
