require 'rails_helper'

RSpec.describe "conversations/index", :type => :view do
  before(:each) do
    assign(:conversations, [
      Conversation.create!(
        :owner_id => "Owner",
        :target_id => "Target",
        :messages_count => "Messages Count"
      ),
      Conversation.create!(
        :owner_id => "Owner",
        :target_id => "Target",
        :messages_count => "Messages Count"
      )
    ])
  end

  it "renders a list of conversations" do
    render
    assert_select "tr>td", :text => "Owner".to_s, :count => 2
    assert_select "tr>td", :text => "Target".to_s, :count => 2
    assert_select "tr>td", :text => "Messages Count".to_s, :count => 2
  end
end
