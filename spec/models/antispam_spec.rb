require 'spec_helper'

describe AntiSpam do
	before do
		Setting.replacelist = {'test' => 'TEST'}
	end
	it "should replace the keyword to target keyword" do
		Post.new.filter_keywords('test test').should == 'TEST TEST'
	end
end