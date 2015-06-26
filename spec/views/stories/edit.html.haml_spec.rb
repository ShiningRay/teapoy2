require 'rails_helper'

RSpec.describe "stories/edit", type: :view do
  before(:each) do
    @story = assign(:story, Story.create!(
      :guestbook => nil,
      :author => nil,
      :body => "MyText"
    ))
  end

  it "renders the edit story form" do
    render

    assert_select "form[action=?][method=?]", story_path(@story), "post" do

      assert_select "input#story_guestbook_id[name=?]", "story[guestbook_id]"

      assert_select "input#story_author_id[name=?]", "story[author_id]"

      assert_select "textarea#story_body[name=?]", "story[body]"
    end
  end
end
