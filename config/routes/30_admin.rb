# coding: utf-8
Teapoy::Application.routes.draw do

  namespace :admin do
    get 'emails/create' => 'emails#create'
    get 'statistic' =>'statistic#index'
    get 'statistic/stats' =>'statistic#stats'
    root :to => 'statistic#stats'
    #root :to => 'dashboard#index', :as => 'dashboard'
    get 'articles/comments/:id' => 'articles#comments'

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

      resources :articles
      resources :transactions
      resources :inboxes
      collection do
        get 'by_state/:by_state' => 'users#index'
      end
    end
    resources :inboxes
    get 'frontpage' => 'frontpage#index', :as => :frontpage
    get 'frontpage/:action' => 'frontpage'

    resources :articles do
      member do
        post :move
        post :track
        post :set_status
      end
      collection do
        post :move
        post :track
        post :batch_set_status
        get 'by_status/:status' => 'articles#index'
      end
      get 'comments' => 'articles#comments'
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
end