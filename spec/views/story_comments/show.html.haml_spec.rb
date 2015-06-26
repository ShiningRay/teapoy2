require 'rails_helper'

RSpec.describe "story_comments/show", type: :view do
  before(:each) do
    @story_comment = assign(:story_comment, StoryComment.create!(
      :story => nil,
      :author => nil,
      :content => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
