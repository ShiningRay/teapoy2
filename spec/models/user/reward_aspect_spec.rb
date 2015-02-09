require 'spec_helper'

describe User::RewardAspect do
  describe 'send reward' do
  end

  describe 'win reward' do
    let(:user){ create :user }

    before do

    end
    it "should calc all the rewards user winned" do
      user.total_winned_rewards.should == 10
    end
  end
end

