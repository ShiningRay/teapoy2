require 'rails_helper'

RSpec.describe "conversations/show", :type => :view do
  before(:each) do
    @conversation = assign(:conversation, Conversation.create!(
      :owner_id => "Owner",
      :target_id => "Target",
      :messages_count => "Messages Count"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Owner/)
    expect(rendered).to match(/Target/)
    expect(rendered).to match(/Messages Count/)
  end
end
