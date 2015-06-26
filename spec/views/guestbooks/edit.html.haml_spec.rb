require 'rails_helper'

RSpec.describe "guestbooks/edit", type: :view do
  before(:each) do
    @guestbook = assign(:guestbook, Guestbook.create!(
      :name => "MyString",
      :owner => "",
      :description => "MyText"
    ))
  end

  it "renders the edit guestbook form" do
    render

    assert_select "form[action=?][method=?]", guestbook_path(@guestbook), "post" do

      assert_select "input#guestbook_name[name=?]", "guestbook[name]"

      assert_select "input#guestbook_owner[name=?]", "guestbook[owner]"

      assert_select "textarea#guestbook_description[name=?]", "guestbook[description]"
    end
  end
end
