# coding: utf-8
Teapoy::Application.routes.draw do
  resource :session
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
end
