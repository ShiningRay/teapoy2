require 'rails_helper'

describe "read_statuses/new" do
  before(:each) do
    assign(:read_status, stub_model(ReadStatus).as_new_record)
  end

  it "renders new read_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => read_statuses_path, :method => "post" do
    end
  end
end
