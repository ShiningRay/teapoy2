# coding: utf-8
require 'rails_helper'

describe "attachments/new" do
  before(:each) do
    assign(:attachment, stub_model(Attachment).as_new_record)
  end

  it "renders new attachment form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => attachments_path, :method => "post" do
    end
  end
end
