require 'rails_helper'

describe "change_logs/edit" do
  before(:each) do
    @change_log = assign(:change_log, stub_model(ChangeLog))
  end

  it "renders the edit change_log form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", change_log_path(@change_log), "post" do
    end
  end
end
