Selfstarter::Application.routes.draw do

  resources :projects,      only: [:index, :edit, :update] do
    resources :subscribers,  only: [:new, :create, :index] do
      resources :subscriptions, only: [:create] do
        collection do
          post :create_with_bank_slip, as: :bank_slip
        end
      end
    end
  end

  resources :subscriptions, only: [:update]
  resources :subscribers, only: [:update]

  namespace :admin do
    resources :sessions, only: [:index, :create]
    resources :subscribers do 
      collection do
        get :bank_slips
        get :payment_instructions
      end
    end
  end
  
  get '/invite/:code',  to: "projects#index",     as: :invite
  get '/obrigado-de-coracao/:id', to: "subscribers#thanks", as: :thank_you
  
  

  get   '/boletos',                 to: "webhooks#bankslips"
  post  '/boletos/status',         to: 'webhooks#status'
  post  '/subscriptions/status',   to: 'webhooks#subscription_status'


  root :to => 'projects#index'
end
