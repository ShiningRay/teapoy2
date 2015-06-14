# coding: utf-8
require 'rails_helper'

describe "reputations/show.html.erb" do
  before(:each) do
    @reputation = assign(:reputation, stub_model(Reputation,
      :user_id => 1,
      :group_id => 1,
      :value => 1,
      :state => "State"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/State/)
  end
end
