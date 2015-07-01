# coding: utf-8
Teapoy::Application.routes.draw do

  #match '/users(.:format)' => 'users#index', :as => :all_users
  # match ':group_id/users(.:format)' => 'users#index', :as => :group_users, :via => :get
  # match 'topics' => 'topics#create', :via => :post, :as => :all_articles
  # match 'topics/new' => 'topics#new', :as => :new_all_article, :via => :get
  # match 'topics/:id/dismiss' => 'topics#dismiss', :as => :dismiss_article, :via => :get
  match 'all/hottest(/:limit)(/page/:page)(.:format)' => 'topics#index',
        :via => :get, :as => :hottest_all_articles,
        :group_id => 'all', :order => 'hottest'
  match 'all/latest(/page/:page)(.:format)' => 'topics#index',
        :via => :get, :as => :latest_all_articles,
        :group_id => 'all', :order => 'latest'

  resources :topics
  match 'topics/repost' => 'topics#repost', :as => :repost_form, :via => :get
  match 'topics/create(.:format)' => 'topics#create', :via => [:post, :patch]
  post 'topics(.:format)' => 'topics#create', group_id: 'all'

  # compat with comments
  get '/topics/:article_id/comments(.:format)' => 'posts#index'
  post '/topics/comments(.:format)' => 'posts#create'

  # compat with old style article path
  get '/:group_id/archives/:id', to: 'archives#show', constraints: { id: /\d{4}(-\d{1,2}(-\d{1,2})?)?/ }
  post '/:group_id/:topic_id/comments(.:format)' => 'posts#create'
  get '/:group_id/:id(.:format)' => 'topics#show'
  get '/:group_id(.:format)' => 'topics#index'

  # resources :groups
  # scope ":group_id", :as => '' do
  #   resources :tickets do
  #     collection do
  #       get :submit
  #     end
  #   end

  #   resources :users

  #   resources :archives, :only => [:index, :show]

  #   resources :topics, :path => ''  do
  #     collection do
  #       get 'latest_comment(/page/:page)(.:format)', :action => :index, :order => 'latest_comment'
  #       get 'latest(/page/:page)(.:format)', :action => :index, :order => 'latest'
  #       #match 'hottest(/:limit)' => 'topics#hottest', :via => :get, :as => :hottest
  #       get 'hottest(/:limit)(/page/:page)(.:format)', :action => :index, :order => 'hottest'
  #       get :pending
  #       get :sitemap
  #       get :feed, :format => :xml
  #       get :search
  #     end

  #     member do
  #       post :subscribe
  #       get :subscribe
  #       post :unsubscribe
  #       get :unsubscribe
  #       post :move
  #       get :move_out
  #       get :delete
  #       get :publish
  #       post :unpublish
  #       get :links

  #     end

  #     resources :comments do
  #       member do
  #         get :up
  #         get :dn
  #       end
  #     end
  #     resources :attachments do
  #       post 'set_price', :on => :member
  #     end
  #     resources :rewards
  #     #match 'feed' => 'topics#index', :via => :get, :format => 'xml', :as => :group_feed
  #   end
  # end


  # match ':group_id(.:format)' => 'topics#index', :as => :group_articles, :via => :get
  # match ':group_id/:id(.:format)' => 'topics#show', :as => :group_article, :via => :get
  # match ':group_id/latest(.:format)' => 'topics#index',
  #       :as => :latest_group_articles, :via => :get,
  #       :order => 'latest'
  # match ':group_id/hottest(/:limit(.:format))' => 'topics#index',
  #       :as => :hottest_group_articles, :via => :get,
  #       :order => 'hottest'
  # match ':group_id/pending(.:format)' => 'topics#pending',
  #       :as => :pending_group_articles  , :via => :get
  # match 'topics/:id/mark' => 'topics#mark', :via => :post
end
