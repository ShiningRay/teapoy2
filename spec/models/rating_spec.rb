# coding: utf-8
# == Schema Information
#
# Table name: ratings
#
#  id         :integer          not null, primary key
#  post_id    :string(24)       default("0"), not null
#  user_id    :integer          default(0), not null
#  score      :integer          default(0), not null
#  created_at :datetime         not null
#

require File.dirname(__FILE__) + '/../spec_helper'

describe Rating do
  before(:each) do

  end

  it "should be valid" do

  end
end
