require 'rails_helper'

describe AntiSpam do
	before do
		Setting.replacelist = {'test' => 'TEST'}
	end
	it "should replace the keyword to target keyword" do
		expect(Post.new.filter_keywords('test test')).to eq('TEST TEST')
	end
end
