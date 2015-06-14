require 'rails_helper'
describe ArchivesController do
  it "should route to show" do
    expect(get '/pool/archives/2012-1-1').to route_to(
      controller: 'archives',
      action: 'show',
      id: '2012-1-1',
      group_id: 'pool')
  end
end
