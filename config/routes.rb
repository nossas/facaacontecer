require 'sidekiq/web'
Selfstarter::Application.routes.draw do

  
  #mount Sidekiq::Web => '/sidekiq' if Rails.env.development? 

  root :to => 'projects#index'


  resources :users, except: [:destroy, :update]
  resources :subscriptions, only: [:show, :edit]
  resources :payments, only: [:show]





  namespace :notifications do
    resources :payments, only: [:create]
  end

  
  get '/invite/:code',                to: "projects#index",     as: :invite
  
  


end
