require 'rails_helper'

RSpec.describe "topics/titles/show", type: :view do
  before(:each) do
    @topics_title = assign(:topics_title, Topics::Title.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
