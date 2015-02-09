# coding: utf-8
require 'spec_helper'

describe Article::ChargeObserver do
  let(:group){create :group, hide: false, private: false}
  let(:author){create :user}
  let(:article){create :article, group: group, user: author, status: 'publish'}

  describe 'when author is not the group owner' do
  	before do
  		author.gain_credit(10)
  	end
  	it "should charge author 10 credit" do

  	end
  end
end
