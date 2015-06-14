# coding: utf-8
require 'rails_helper'

describe "attachments/show" do
  before(:each) do
    @attachment = assign(:attachment, stub_model(Attachment))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
