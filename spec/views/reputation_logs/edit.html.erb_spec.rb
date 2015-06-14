# coding: utf-8
require 'rails_helper'

describe "reputation_logs/edit" do
  before(:each) do
    @reputation_log = assign(:reputation_log, stub_model(ReputationLog,
      :reputation_id => 1,
      :post_id => 1,
      :amount => 1,
      :reason => "MyString"
    ))
  end

  it "renders the edit reputation_log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reputation_logs_path(@reputation_log), :method => "post" do
      assert_select "input#reputation_log_reputation_id", :name => "reputation_log[reputation_id]"
      assert_select "input#reputation_log_post_id", :name => "reputation_log[post_id]"
      assert_select "input#reputation_log_amount", :name => "reputation_log[amount]"
      assert_select "input#reputation_log_reason", :name => "reputation_log[reason]"
    end
  end
end
