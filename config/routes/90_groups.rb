# coding: utf-8
Teapoy::Application.routes.draw do

  #match '/users(.:format)' => 'users#index', :as => :all_users
  # match ':group_id/users(.:format)' => 'users#index', :as => :group_users, :via => :get
  # match 'articles' => 'articles#create', :via => :post, :as => :all_articles
  match 'articles/repost' => 'articles#repost', :as => :repost_form, :via => :get
  match 'articles/create(.:format)' => 'articles#create', :via => [:post, :patch]
  # match 'articles/new' => 'articles#new', :as => :new_all_article, :via => :get
  # match 'articles/:id/dismiss' => 'articles#dismiss', :as => :dismiss_article, :via => :get
  match 'all/hottest(/:limit)(/page/:page)(.:format)' => 'articles#index',
        :via => :get, :as => :hottest_all_articles,
        :group_id => 'all', :order => 'hottest'
  match 'all/latest(/page/:page)(.:format)' => 'articles#index',
        :via => :get, :as => :latest_all_articles,
        :group_id => 'all', :order => 'latest'
  get ':group_id/:id' => 'articles#show'
  get ':group_id' => 'articles#index'

  # resources :groups
  # scope ":group_id", :as => '' do
  #   resources :tickets do
  #     collection do
  #       get :submit
  #     end
  #   end

  #   resources :users

  #   resources :archives, :only => [:index, :show]

  #   resources :articles, :path => ''  do
  #     collection do
  #       get 'latest_comment(/page/:page)(.:format)', :action => :index, :order => 'latest_comment'
  #       get 'latest(/page/:page)(.:format)', :action => :index, :order => 'latest'
  #       #match 'hottest(/:limit)' => 'articles#hottest', :via => :get, :as => :hottest
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
  #     #match 'feed' => 'articles#index', :via => :get, :format => 'xml', :as => :group_feed
  #   end
  # end


  # match ':group_id(.:format)' => 'articles#index', :as => :group_articles, :via => :get
  # match ':group_id/:id(.:format)' => 'articles#show', :as => :group_article, :via => :get
  # match ':group_id/latest(.:format)' => 'articles#index',
  #       :as => :latest_group_articles, :via => :get,
  #       :order => 'latest'
  # match ':group_id/hottest(/:limit(.:format))' => 'articles#index',
  #       :as => :hottest_group_articles, :via => :get,
  #       :order => 'hottest'
  # match ':group_id/pending(.:format)' => 'articles#pending',
  #       :as => :pending_group_articles  , :via => :get
  # match 'articles/:id/mark' => 'articles#mark', :via => :post
end
