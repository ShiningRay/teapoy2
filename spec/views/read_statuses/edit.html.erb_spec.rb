require 'rails_helper'

describe "read_statuses/edit" do
  before(:each) do
    @read_status = assign(:read_status, stub_model(ReadStatus))
  end

  it "renders the edit read_status form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => read_statuses_path(@read_status), :method => "post" do
    end
  end
end
