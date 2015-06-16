# -*- coding: utf-8 -*-
require 'rails_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
#include AuthenticatedTestHelper

describe User::BalanceAspect do
  #fixtures :users
  let(:user){create(:user)}
  describe '#gain_credit' do
    it "gains credits" do
      amount = rand(1..100)
      expect{
        user.gain_credit(amount,"hello")
      }.to change{user.credit}.by(amount)
    end

    it "creates a transaction" do
      amount = rand(1..100)
      expect{
        user.gain_credit(amount,"hello")
      }.to change{ user.transactions.count }.by(1)
      tx = user.transactions.first
      expect(tx.amount).to eq(amount)
      expect(tx.reason).to eq('hello')
    end

    context "user's balance is empty" do
      it "should not have minus balance" do
        expect{user.gain_credit(-4, 'abc')}.to raise_error Balance::InsufficientFunds
        expect(user.credit).to eq(0)
        expect(user.transactions).to be_empty
      end
    end
  end

  context "A user who have some credit and want to spend credit" do
    let(:user) { create(:rich_user) }

    it "should spend credit" do
      expect{
        user.spend_credit(10, 'buy goods')
      }.to change{
        user.credit
      }.by(-10)
    end

    it "creates a transaction" do
      expect{
        user.spend_credit(10, 'buy goods')
      }.to change{
        user.transactions.count
      }.by(1)
      tx = user.transactions.last
      expect(tx.amount).to eq(-10)
      expect(tx.reason).to eq('buy goods')
    end
  end
end
