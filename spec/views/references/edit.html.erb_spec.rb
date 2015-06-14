# coding: utf-8
require 'rails_helper'

describe "references/edit" do
  before(:each) do
    @reference = assign(:reference, stub_model(Reference))
  end

  it "renders the edit reference form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => references_path(@reference), :method => "post" do
    end
  end
end
