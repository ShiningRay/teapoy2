# -*- coding: utf-8 -*-
require 'spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
#include AuthenticatedTestHelper

describe User::BalanceAspect do
  #fixtures :users
  let(:user){create(:user)}
  describe '#gain_credit' do
    it "should gain credits and create a transaction" do
      user.gain_credit(4,"hello")
      user.credit.should == 4
      user.transactions.size.should == 1
      tx = user.transactions.first
      tx.amount.should == 4
      tx.reason.should == 'hello'
    end

    context "user's balance is empty" do
      it "should not have minus balance" do
        expect{user.gain_credit(-4, 'abc')}.to raise_error Balance::InsufficientFunds
        user.credit.should == 0
        user.transactions.should be_empty
      end
    end
  end

  context "A user who have some credit and want to spend credit" do
    let(:user) do
      u = create(:user)
      u.balance = create(:balance, :rich, user: u)
      u
    end

    it "should spend credit and create a transaction" do
      expect{
          user.spend_credit(10, 'buy goods')
        }.to change{
          user.transactions.size
        }.by(1)
      user.credit.should == 90
      tx = user.transactions.last
      tx.amount.should == -10
      tx.reason.should == 'buy goods'
    end
  end
end
