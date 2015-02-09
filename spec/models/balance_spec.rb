require 'spec_helper'

describe Balance do
  let(:user) {create(:user)}
  it "should not have minus credit" do
    user.balance.credit = -10
    expect{user.balance.save!}.to raise_error
  end
end