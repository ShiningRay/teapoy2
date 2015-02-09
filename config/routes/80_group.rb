# coding: utf-8
Teapoy::Application.routes.draw do
  get '/groups/:group_id/reject_join/:user_id' => "groups#reject_join", :as => :reject_join_group
  get '/groups/:group_id/allow_join/:user_id' => "groups#allow_join", :as => :allow_join_group
  
  resources :groups do
    member do
      post :join
      post :quit
      post :invite
      get :judge_articles
      post :editinfo
    end

    collection do
      get :search
    end

    resources :articles do
      collection do
        get 'latest_comment(/page/:page)(.:format)', :action => :index, :order => 'latest_comment'
        get 'latest(/page/:page)(.:format)', :action => :index, :order => 'latest', :as => 'latest'
        #match 'hottest(/:limit)' => 'articles#hottest', :via => :get, :as => :hottest
        get 'hottest(/:limit)(/page/:page)(.:format)', :action => :index, :order => 'hottest', :as => 'hottest'
        get :pending
        get :sitemap
        get :feed, :format => :xml
        get :search
      end

      member do
        post :subscribe
        get :subscribe
        post :unsubscribe
        get :unsubscribe
        post :move
        get :move_out
        get :delete
        get :publish
        post :unpublish
        get :links

      end

      resources :comments do
        member do
          get :up
          get :dn
        end
      end
      resources :attachments do
        post 'set_price', :on => :member
      end
      resources :rewards
      #match 'feed' => 'articles#index', :via => :get, :format => 'xml', :as => :group_feed
    end

    resources :archives, :only => [:index, :show]

    resources :tickets do
      collection do
        get :submit
      end
    end

    resources :memberships
    resources :users

  end
end
