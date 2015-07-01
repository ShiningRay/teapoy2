require 'rails_helper'

describe ArchivesController do
  it 'should route to show' do
    expect(get '/groups/pool/archives/2012-1-1').to route_to(
      controller: 'archives',
      action: 'show',
      id: '2012-1-1',
      group_id: 'pool')
  end

  it 'routes old style to show' do
    expect(get '/pool/archives/2013-04-05').to route_to(
      controller: 'archives',
      action: 'show',
      id: '2013-04-05',
      group_id: 'pool'
    )
  end
end
