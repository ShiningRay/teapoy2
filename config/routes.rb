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

  post '/upload', to: 'attachments#upload'

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
  get 'new_index' => 'home#test_new_index'
  get 'home/:action' => 'home'
  get 'all(/page/:page)' => 'topics#index', :group_id => 'all'
  get 'register/:action' => 'register'
  get 'scores' => 'topics#scores'
  resources :subscriptions
  get '/tags/edit' => 'tags#edit'
  resources :tags
  get '/search' => 'topics#search', :group_id => 'all'

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

  post '/posts/:id/up', to: 'posts#up', as: :up_post
  post '/posts/:id/dn', to: 'posts#dn', as: :dn_post
  get '/posts/scores.json', to: 'posts#scores'
  # resources :posts do
  #   member do
  #     post :repost
  #     get :up
  #     get :dn
  #     post :reply
  #     get :children
  #     post :repost
  #   end
  # end

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

  #match 'scores' => 'topics#scores'
  #match 'votes' => 'topics#votes'

  resources :salaries do
    member do
      get 'get'
      post 'get'
    end

    collection do
      get 'get_all'
    end
  end

  match 'invite_to_group'=> 'users#invite_to_group', :via => :post, :as => :invite_to_group
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
  #match ':group_id/:id(.:format)', :to => 'topics#show', :as => :topic
  #match ':id', :to => 'groups#show', :as => :group
  #root :to => 'tags#show', :id => '搞笑'
  root :to => 'topics#index', :group_id => 'all'
  #root :to => 'home#index'
  # get ':controller(/:action(/:id(.:format)))'
  post '/token' => 'users#token'
  get "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback, :via => :get

  namespace :admin do
    get 'emails/create' => 'emails#create'
    get 'statistic' =>'statistic#index'
    get 'statistic/stats' =>'statistic#stats'
    root :to => 'statistic#stats'
    #root :to => 'dashboard#index', :as => 'dashboard'
    get 'topics/comments/:id' => 'topics#comments'

    get '/' => 'statistic#index', :as => 'dashboard'

    resources :users do
      member do
        get :publicate_groups
        get :comments
        post :suspend
        post :unsuspend
        post :activate
        post :delete_avatar
        post :delete_comments
        post :add_credit
        post :join_group
        post :quit_group
      end

      resources :topics
      resources :transactions
      resources :inboxes
      collection do
        get 'by_state/:by_state' => 'users#index'
      end
    end
    resources :inboxes
    get 'frontpage' => 'frontpage#index', :as => :frontpage
    get 'frontpage/:action' => 'frontpage'

    resources :topics do
      member do
        post :move
        post :track
        post :set_status
      end
      collection do
        post :move
        post :track
        post :batch_set_status
        get 'by_status/:status' => 'topics#index'
      end
      get 'comments' => 'topics#comments'
    end

    resources :groups do
      member do
        get :moveup
        get :movedown
      end
      collection do
        post :merge
      end
    end
    #resources :themes
    resources :ticket_types
    resources :announcements
    resources :badges
    #resources :invitation_codes, :collection => {:generate => :post}
    #resources :reports, :member => {:ignore => :post, :remove => :post},
    #  :collection => {:batch => :post}
    get 'keywords(/:action)' => 'keywords'
  end

### users {{{
  resource :session, only: [:new, :create, :destroy, :show]
  get '/logout' => 'sessions#destroy', :as => :logout
  get '/login' => 'sessions#new', :as => :login
  # get '/register' => 'register#create_account', :as => :register
  # get '/signup' => 'register#create_account', :as => :signup
  get '/signup' => 'users#new', as: :signup

  resources :password_resets, :only => [:new, :create, :edit, :update]
  get '/activate/:activation_code' => 'users#activate', :as => :activate
  resource :password, module: 'users', only: [:edit, :update]

  resources :users do
    #resources :read_statuses, :only => [:create]
    #resources :posts
    #resources :profiles
    resources :badges

    resources :reputation_logs
    resources :reputations
    resources :friendships do
      collection do
        get :followers
        get :followings
      end
    end
    resources :dislikes, :module => 'users', :only => [:index, :create, :destroy]
    resource :avatar, :module => 'users', :only => [:edit, :update, :destroy]
    #resources :friendships

    member do
      get 'follow'
      post 'follow'
      get 'unfollow'
      post 'unfollow'
      get 'followers'
      get 'followings'
      get 'binding'
      post 'dislike'
      get 'dislike'
      post 'cancel_dislike'
    end

    resources :topics, :module => 'users', :only => :index do
      collection do
        get :hottest
        get 'hottest(/:limit/(page/:page))' => 'topics#index', :order => 'hottest'
        get 'page/:page' => 'topics#index', :order => 'latest'
        get 'latest' => 'topics#index'
      end
    end

    resources :groups do
      resources :reputation_logs
      resources :topics, :module => 'users', :only => :index do
        collection do
          get :hottest
          get 'page/:page' => 'topics#index', :order => 'latest'
          get 'latest(/page/:page)' => 'topics#index', :order => 'latest'
          get 'hottest(/:limit(/page/:page))' => 'topics#index', :order => 'hottest'
        end
      end
    end
  end
### }}}

### groups {{{
  post '/groups/:group_id/reject_join/:user_id' => 'groups#reject_join', :as => :reject_join_group
  post '/groups/:group_id/allow_join/:user_id' => 'groups#allow_join', :as => :allow_join_group


  get '/groups/:group_id/articles(.:format)' => 'topics#index'
  get '/groups/:group_id/articles/new(.:format)' => 'topics#new'
  get '/groups/:group_id/articles/:id(.:format)' => 'topics#show'
  get '/groups/:group_id/articles/:topic_id/comments(.:format)' => 'comments#index'
  post '/groups/:group_id/articles/:topic_id/comments(.:format)' => 'posts#create'
  get '/groups/:group_id/topics/:topic_id/comments(.:format)' => 'comments#index'
  post '/groups/:group_id/topics/:topic_id/comments(.:format)' => 'posts#create'
  resources :groups do
    member do
      post :join
      post :quit
      post :invite
      get :judge_articles
    end

    collection do
      get :search
    end

    resources :topics do
      resource :title, module: 'topics', only: :update
      collection do
        get 'latest_comment(/page/:page)(.:format)', :action => :index, :order => 'latest_comment'
        get 'latest(/page/:page)(.:format)', :action => :index, :order => 'latest', :as => 'latest'
        #match 'hottest(/:limit)' => 'topics#hottest', :via => :get, :as => :hottest
        get 'hottest(/:limit)(/page/:page)(.:format)', :action => :index, :order => 'hottest', :as => 'hottest'
        get :pending
        get :sitemap
        get :feed, :format => :xml
        get :search
      end

      member do
        post :subscribe
        post :unsubscribe
        post :move
        post :unpublish
      end

      resources :posts do
        member do
          get :up
          get :dn
        end
      end
      resources :attachments do
        post 'set_price', :on => :member
      end
      resources :rewards
      #match 'feed' => 'topics#index', :via => :get, :format => 'xml', :as => :group_feed
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
### }}}

### topics {{{

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
  post '/groups/:group_id/:topic_id/comments(.:format)' => 'posts#create'
  # compat with old style article path
  get '/:group_id/archives/:id', to: 'archives#show', constraints: { id: /\d{4}(-\d{1,2}(-\d{1,2})?)?/ }
  post '/:group_id/:topic_id/comments(.:format)' => 'posts#create'

  get '/:group_id/:topic_id/comments(.:format)' => 'comments#index'

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

### }}}
end
# Dir[Rails.root.join('config/routes/*.rb')].sort.each{|r| require_dependency(r)}
