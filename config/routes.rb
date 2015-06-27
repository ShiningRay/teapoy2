# coding: utf-8
# Dir[Rails.root.join("config/routes/*.rb")].sort.each do |route|
#   puts "loading route #{route}"
#   eval IO.read(route), binding, route
# end

Teapoy::Application.routes.draw do


  resources :guestbooks do
    resources :stories do
      resources :story_comments, path: 'comments', only: %i(index create destroy)
      resources :likers, only: [:index, :create, :destroy]
      member do
        post :like
        post :unlike
      end
    end
  end

  resources :conversations, only: %w(index show new create destroy) do
    resources :messages
  end

  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/sidekiq'#, :constraints => AdminConstraint.new
  resources :references
  resources :change_logs
  resources :rewards
  resource :weixin

  themes_for_rails
  get 'new_index' => "home#test_new_index"
  get 'home/:action' => 'home'
  get 'all(/page/:page)' => 'articles#index', :group_id => 'all'
  get 'register/:action' => 'register'
  get 'scores' => 'articles#scores'
  resources :subscriptions
  get '/tags/edit' => 'tags#edit'
  resources :tags
  get '/search' => 'articles#search', :group_id => 'all'

  resources :badges, :only => [:index, :show]
  # resources :collections do
  #   get :select, :on => :collection
  #   post :append, :on => :collection
  #   post :remove, :on => :member
  #   post :publish, :on => :member
  # end
  #resources :quest_logs
  #resources :quests do
  #  member do
  #    get :complete
  #    get :check
  #  end
  #end

  resources :lists do
    # resources :list_items
    member do
      post :append
      post :sort
    end
  end

  resources :posts do
    member do
      post :repost
      get :up
      get :dn
      post :reply
      get :children
      post :repost
    end
  end

  #resources :invitation_codes
  #resources :badges

  resources :messages do
    collection do
      get :inbox
      get :outbox
    end
  end

  resources :notifications do
    collection do
      get :clear_all
      post :ignore
      get :clear
    end

    member do
      get :dismiss
    end
  end

  #match 'scores' => 'articles#scores'
  #match 'votes' => 'articles#votes'

  resources :salaries do
    member do
      get 'get'
      post 'get'
    end

    collection do
      get 'get_all'
    end
  end

  match 'invite_to_group'=> "users#invite_to_group", :via => :post, :as => :invite_to_group
  # match 'register/check'=> "register#check"
  # get 'my/index' => 'my#inbox'
  # get 'my/:action(.:format)' => 'my'
  get 'my/tools/:action(.:format)' => 'tools'


  get '/users/:id/lists' => 'users#lists', :as => :user_lists
  get 'sitemap_index.xml' => 'groups#sitemap_index', :as => :sitemap_index, :format => :xml
  # match 'favicon.ico' => 'groups#favicon'
  # match ':controller/:action/:id/page/:page' => '#index', :constraints => { :page => /\d+/ }
  # match ':controller/:action/page/:page' => '#index', :constraints => { :page => /\d+/ }

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get :short
  #       post :toggle
  #     end
  #
  #     collection do
  #       get :sold
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get :recent, :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  #match 'my/(:action(.:format))', :to => 'my'
  #match ':group_id/:year/(:month/(:day))', :to => 'groups#archive', :constraints => {:year => /\d{4}/, :month => /\d{1,2}/, :day => /\d{1,2}/ }
  #match ':group_id/:id(.:format)', :to => 'articles#show', :as => :article
  #match ':id', :to => 'groups#show', :as => :group
  #root :to => 'tags#show', :id => '搞笑'
  get ':group_id/archives/:id' => 'archives#show'
  root :to => 'articles#index', :group_id => 'all'
  #root :to => 'home#index'
  # get ':controller(/:action(/:id(.:format)))'
  get '/articles/:article_id/comments(.:format)' => 'comments#index'
  post '/articles/comments(.:format)' => 'comments#create'
end
Dir[Rails.root.join("config/routes/*.rb")].sort.each{|r| require_dependency(r)}
