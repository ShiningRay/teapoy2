require 'rails_helper'

RSpec.describe "topics/titles/index", type: :view do
  before(:each) do
    assign(:topics_titles, [
      Topics::Title.create!(),
      Topics::Title.create!()
    ])
  end

  it "renders a list of topics/titles" do
    render
  end
end
