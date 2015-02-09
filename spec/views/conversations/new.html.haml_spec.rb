require 'rails_helper'

RSpec.describe "conversations/new", :type => :view do
  before(:each) do
    assign(:conversation, Conversation.new(
      :owner_id => "MyString",
      :target_id => "MyString",
      :messages_count => "MyString"
    ))
  end

  it "renders new conversation form" do
    render

    assert_select "form[action=?][method=?]", conversations_path, "post" do

      assert_select "input#conversation_owner_id[name=?]", "conversation[owner_id]"

      assert_select "input#conversation_target_id[name=?]", "conversation[target_id]"

      assert_select "input#conversation_messages_count[name=?]", "conversation[messages_count]"
    end
  end
end
