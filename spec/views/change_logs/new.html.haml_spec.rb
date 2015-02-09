require 'spec_helper'

describe "change_logs/new" do
  before(:each) do
    assign(:change_log, stub_model(ChangeLog).as_new_record)
  end

  it "renders new change_log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", change_logs_path, "post" do
    end
  end
end
