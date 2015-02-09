# coding: utf-8
require 'spec_helper'

describe "references/index" do
  before(:each) do
    assign(:references, [
      stub_model(Reference),
      stub_model(Reference)
    ])
  end

  it "renders a list of references" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
