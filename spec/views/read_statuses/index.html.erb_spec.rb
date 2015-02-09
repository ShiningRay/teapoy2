require 'spec_helper'

describe "read_statuses/index" do
  before(:each) do
    assign(:read_statuses, [
      stub_model(ReadStatus),
      stub_model(ReadStatus)
    ])
  end

  it "renders a list of read_statuses" do
    render
  end
end
