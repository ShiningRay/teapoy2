# coding: utf-8
# == Schema Information
#
# Table name: settings
#
#  id    :integer          not null, primary key
#  key   :string(255)      not null
#  value :text             not null
#

require 'rails_helper'

describe Setting do
  describe '.[]' do
    it "reads out stored string correctly" do
      Setting[:test_key] = 'test_value'
      expect(Setting[:test_key]).to eq( 'test_value')
      expect(Setting.test_key).to eq( 'test_value')
    end
  end
  
  describe '.[]=' do
    it "saves hash correctly" do
      Setting.test_key = {'test' => 'test2'}
      expect(Setting.test_key).to include('test')
      expect(Setting.test_key['test']).to eq( 'test2')
    end
  end
end
