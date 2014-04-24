Selfstarter::Application.routes.draw do
  root :to => 'projects#index'

  resources :users, except: [:destroy, :update]

  resources :payments, only: [:show] do
    member do
      get :retry
    end
  end

  resources :subscriptions, only: [:show] do
    member do
      get :confirm
    end
  end

  namespace :notifications do
    resources :payments, only: [:create]
    resources :recurring_payments, only: [:create]
  end

  get '/invite/:code',                to: "projects#index",     as: :invite
end
