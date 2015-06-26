require 'rails_helper'

RSpec.describe "story_comments/edit", type: :view do
  before(:each) do
    @story_comment = assign(:story_comment, StoryComment.create!(
      :story => nil,
      :author => nil,
      :content => "MyText"
    ))
  end

  it "renders the edit story_comment form" do
    render

    assert_select "form[action=?][method=?]", story_comment_path(@story_comment), "post" do

      assert_select "input#story_comment_story_id[name=?]", "story_comment[story_id]"

      assert_select "input#story_comment_author_id[name=?]", "story_comment[author_id]"

      assert_select "textarea#story_comment_content[name=?]", "story_comment[content]"
    end
  end
end
