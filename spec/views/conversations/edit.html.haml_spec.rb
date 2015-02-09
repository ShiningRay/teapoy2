require 'rails_helper'

RSpec.describe "conversations/edit", :type => :view do
  before(:each) do
    @conversation = assign(:conversation, Conversation.create!(
      :owner_id => "MyString",
      :target_id => "MyString",
      :messages_count => "MyString"
    ))
  end

  it "renders the edit conversation form" do
    render

    assert_select "form[action=?][method=?]", conversation_path(@conversation), "post" do

      assert_select "input#conversation_owner_id[name=?]", "conversation[owner_id]"

      assert_select "input#conversation_target_id[name=?]", "conversation[target_id]"

      assert_select "input#conversation_messages_count[name=?]", "conversation[messages_count]"
    end
  end
end
