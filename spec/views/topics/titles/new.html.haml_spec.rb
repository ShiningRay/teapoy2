require 'rails_helper'

RSpec.describe "topics/titles/new", type: :view do
  before(:each) do
    assign(:topics_title, Topics::Title.new())
  end

  it "renders new topics_title form" do
    render

    assert_select "form[action=?][method=?]", topics_titles_path, "post" do
    end
  end
end
