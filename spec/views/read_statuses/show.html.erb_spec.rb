require 'spec_helper'

describe "read_statuses/show" do
  before(:each) do
    @read_status = assign(:read_status, stub_model(ReadStatus))
  end

  it "renders attributes in <p>" do
    render
  end
end
