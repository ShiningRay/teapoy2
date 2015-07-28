#topics_routing_spec.rb
require "rails_helper"

RSpec.describe TopicsController, type: :routing do
  describe "routing topics" do
    it 'routes to #index' do
      expect(get: '/topics').to route_to('topics#index')
    end

    it "routes to #new" do
      expect(:get => "/topics/new").to route_to("topics#new")
    end

    it "routes to #show" do
      expect(:get => "/topics/1").to route_to("topics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/topics/1/edit").to route_to("topics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/topics").to route_to("topics#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/topics/1").to route_to("topics#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/topics/1").to route_to("topics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/topics/1").to route_to("topics#destroy", :id => "1")
    end
  end

  describe 'routing group topics' do
    it "routes to #index" do
      expect(:get => "/groups/123/topics").to route_to('topics#index', group_id: '123')
    end

    it 'routes to #show' do
      expect(get: '/groups/123/topics/234').to route_to('topics#show', group_id: '123', id: '234')
    end

    it 'routes to #new' do
      expect(get: '/groups/123/topics/new').to route_to('topics#new', group_id: '123')
    end

    it 'routes to #create' do
      expect(post: '/groups/123/topics').to route_to('topics#create', group_id: '123')
    end

    it 'routes to #unsubscribe' do
      expect(post: '/groups/123/topics/456/unsubscribe').to route_to('topics#unsubscribe', id: '456', group_id: '123')
    end

  end

  describe 'routing old article styles' do
    it 'routes to #index' do
      expect(get: '/pool/12345').to route_to('topics#show', group_id: 'pool', id: '12345')
    end

    it 'routes to #new' do
      expect(get: '/groups/pool/articles/new').to route_to('topics#new', group_id: 'pool')
    end

    it 'routes to #show' do
      expect(get: '/groups/pool/articles/12345').to route_to('topics#show', group_id: 'pool', id: '12345')
      expect(get: '/pool/12345').to route_to('topics#show', group_id: 'pool', id: '12345')
    end
  end
end
