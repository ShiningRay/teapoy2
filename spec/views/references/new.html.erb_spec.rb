# coding: utf-8
require 'spec_helper'

describe "references/new" do
  before(:each) do
    assign(:reference, stub_model(Reference).as_new_record)
  end

  it "renders new reference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => references_path, :method => "post" do
    end
  end
end
