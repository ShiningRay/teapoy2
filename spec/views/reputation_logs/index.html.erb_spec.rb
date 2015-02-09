# coding: utf-8
require 'spec_helper'

describe "reputation_logs/index" do
  before(:each) do
    assign(:reputation_logs, [
      stub_model(ReputationLog,
        :reputation_id => 1,
        :post_id => 1,
        :amount => 1,
        :reason => "Reason"
      ),
      stub_model(ReputationLog,
        :reputation_id => 1,
        :post_id => 1,
        :amount => 1,
        :reason => "Reason"
      )
    ])
  end

  it "renders a list of reputation_logs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Reason".to_s, :count => 2
  end
end
