# coding: utf-8
require 'rails_helper'

describe "reputations/index.html.erb" do
  before(:each) do
    assign(:reputations, [
      stub_model(Reputation,
        :user_id => 1,
        :group_id => 1,
        :value => 1,
        :state => "State"
      ),
      stub_model(Reputation,
        :user_id => 1,
        :group_id => 1,
        :value => 1,
        :state => "State"
      )
    ])
  end

  it "renders a list of reputations" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
