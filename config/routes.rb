require 'sidekiq/web'
Selfstarter::Application.routes.draw do


  root :to => 'projects#index'
  
  resources :users, except: [:destroy, :update]
  resources :subscriptions, only: [:show, :edit]
  resources :payments, only: [:show]

  mount Sidekiq::Web => '/sidekiq'






  
  get '/invite/:code',                to: "projects#index",     as: :invite
  
  


end
