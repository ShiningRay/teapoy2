# coding: utf-8
require 'rails_helper'

describe Setting do
  describe '.[]' do
    it "reads out stored string correctly" do
      Setting[:test_key] = 'test_value'
      Setting[:test_key].should == 'test_value'
      Setting.test_key.should == 'test_value'
    end
  end
  describe '.[]=' do
    it "saves hash correctly" do
      Setting.test_key = {'test' => 'test2'}
      Setting.test_key.should include('test')
      Setting.test_key['test'].should == 'test2'
    end
  end
end
