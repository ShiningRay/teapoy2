# coding: utf-8
require 'rails_helper'

describe "reputation_logs/show" do
  before(:each) do
    @reputation_log = assign(:reputation_log, stub_model(ReputationLog,
      :reputation_id => 1,
      :post_id => 1,
      :amount => 1,
      :reason => "Reason"
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
    rendered.should match(/Reason/)
  end
end
