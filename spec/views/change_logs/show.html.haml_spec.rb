require 'spec_helper'

describe "change_logs/show" do
  before(:each) do
    @change_log = assign(:change_log, stub_model(ChangeLog))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
