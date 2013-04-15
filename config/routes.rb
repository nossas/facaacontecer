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

  get '/invite/:code',  to: "projects#index",     as: :invite
  get '/obrigado-de-coracao/:id', to: "subscribers#thanks", as: :thank_you
  get '/obrigado-de-coracao/boleto/:id', to: 'subscribers#bankslip_thanks', as: :bankslip_thank_you

  root :to => 'projects#index'
end
