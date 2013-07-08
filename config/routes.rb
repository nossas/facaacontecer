Selfstarter::Application.routes.draw do

  resources :projects,      only: [:index, :edit, :update] do
    resources :subscribers,  only: [:new, :create] do
      resources :subscriptions, only: [:create] do
        collection do
          post :create_with_bank_slip, as: :bank_slip
        end
      end
    end
  end

  namespace :admin do
    resources :subscribers, only: [:index]
  end
  
  get '/invite/:code',  to: "projects#index",     as: :invite
  get '/obrigado-de-coracao/:id', to: "subscribers#thanks", as: :thank_you
  
  

  get '/boletos',  to: "webhooks#bankslips"


  root :to => 'projects#index'
end
