require 'rails_helper'

describe "change_logs/index" do
  before(:each) do
    assign(:change_logs, [
      stub_model(ChangeLog),
      stub_model(ChangeLog)
    ])
  end

  it "renders a list of change_logs" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
