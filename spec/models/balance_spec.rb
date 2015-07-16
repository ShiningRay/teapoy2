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
# Indexes
#
#  index_balances_on_user_id  (user_id) UNIQUE
#

require 'rails_helper'

describe Balance do
  let(:user) {create(:user)}
  it "should not have minus credit" do
    user.balance.credit = -10
    expect { user.balance.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
