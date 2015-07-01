# posts_routing_spec.rb

require "rails_helper"

RSpec.describe PostsController, type: :routing do
  describe "routing" do
    it 'routes to #create' do
      expect(post: '/groups/pool/topics/123/posts').to route_to('posts#create', group_id: 'pool', topic_id: '123')
    end
  end

  describe 'routing old styles' do
    it 'routes to #create' do
      expect(post: '/pool/123/comments.html').to route_to('posts#create', group_id: 'pool', topic_id: '123', format: 'html')
      expect(post: '/groups/pool/123/comments.html').to route_to('posts#create', group_id: 'pool', topic_id: '123', format: 'html')
      expect(post: '/groups/pool/articles/123/comments').to route_to('posts#create', group_id: 'pool', topic_id: '123')
      expect(post: '/groups/pool/topics/123/comments.js').to route_to('posts#create', group_id: 'pool', topic_id: '123', format: 'js')

    end
  end
end
