require 'spec_helper'

describe "rewards/show" do
  before(:each) do
    @reward = assign(:reward, stub_model(Reward))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
