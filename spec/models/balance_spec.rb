# == Schema Information
#
# Table name: balances
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  charm      :integer          default(0), not null
#  credit     :integer          default(0), not null
#  level      :integer          default(0), not null
#  created_at :datetime
#  updated_at :datetime
#

require 'rails_helper'

describe Balance do
  let(:user) {create(:user)}
  it "should not have minus credit" do
    user.balance.credit = -10
    expect{user.balance.save!}.to raise_error
  end
end
