require 'rails_helper'

RSpec.describe "topics/titles/edit", type: :view do
  before(:each) do
    @topics_title = assign(:topics_title, Topics::Title.create!())
  end

  it "renders the edit topics_title form" do
    render

    assert_select "form[action=?][method=?]", topics_title_path(@topics_title), "post" do
    end
  end
end
