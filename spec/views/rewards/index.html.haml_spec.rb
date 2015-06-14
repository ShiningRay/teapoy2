require 'rails_helper'

describe "rewards/index" do
  before(:each) do
    assign(:rewards, [
      stub_model(Reward),
      stub_model(Reward)
    ])
  end

  it "renders a list of rewards" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
