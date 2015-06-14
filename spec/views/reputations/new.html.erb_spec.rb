# coding: utf-8
require 'rails_helper'

describe "reputations/new.html.erb" do
  before(:each) do
    assign(:reputation, stub_model(Reputation,
      :user_id => 1,
      :group_id => 1,
      :value => 1,
      :state => "MyString"
    ).as_new_record)
  end

  it "renders new reputation form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => reputations_path, :method => "post" do
      assert_select "input#reputation_user_id", :name => "reputation[user_id]"
      assert_select "input#reputation_group_id", :name => "reputation[group_id]"
      assert_select "input#reputation_value", :name => "reputation[value]"
      assert_select "input#reputation_state", :name => "reputation[state]"
    end
  end
end
