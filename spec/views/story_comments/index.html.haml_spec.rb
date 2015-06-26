require 'rails_helper'

RSpec.describe "story_comments/index", type: :view do
  before(:each) do
    assign(:story_comments, [
      StoryComment.create!(
        :story => nil,
        :author => nil,
        :content => "MyText"
      ),
      StoryComment.create!(
        :story => nil,
        :author => nil,
        :content => "MyText"
      )
    ])
  end

  it "renders a list of story_comments" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
