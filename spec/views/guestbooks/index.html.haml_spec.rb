require 'rails_helper'

RSpec.describe "guestbooks/index", type: :view do
  before(:each) do
    assign(:guestbooks, [
      Guestbook.create!(
        :name => "Name",
        :owner => "",
        :description => "MyText"
      ),
      Guestbook.create!(
        :name => "Name",
        :owner => "",
        :description => "MyText"
      )
    ])
  end

  it "renders a list of guestbooks" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
