require 'rails_helper'

RSpec.describe "story_comments/new", type: :view do
  before(:each) do
    assign(:story_comment, StoryComment.new(
      :story => nil,
      :author => nil,
      :content => "MyText"
    ))
  end

  it "renders new story_comment form" do
    render

    assert_select "form[action=?][method=?]", story_comments_path, "post" do

      assert_select "input#story_comment_story_id[name=?]", "story_comment[story_id]"

      assert_select "input#story_comment_author_id[name=?]", "story_comment[author_id]"

      assert_select "textarea#story_comment_content[name=?]", "story_comment[content]"
    end
  end
end
