# groups_routing_spec.rb

require 'rails_helper'

describe GroupsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/groups').to route_to('groups#index')
  end

  it 'routes to #show' do
    expect(get: '/groups/1').to route_to('groups#show', id: '1')
  end

  it 'routes to #join' do
    expect(post: '/groups/1/join').to route_to('groups#join', id: '1')
  end

  it 'routes to #quit' do
    expect(post: '/groups/1/quit').to route_to('groups#quit', id: '1')
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
