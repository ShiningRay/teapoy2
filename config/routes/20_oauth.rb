# coding: utf-8
Teapoy::Application.routes.draw do
  post '/token' => 'users#token'
  get "syncs/:type/new" => "syncs#new", :as => :sync_new
  match "syncs/:type/callback" => "syncs#callback", :as => :sync_callback, :via => :get
end