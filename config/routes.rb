Selfstarter::Application.routes.draw do

  resources :projects,      only: [:index, :edit, :update] do
    resources :subscribers,  only: [:new, :create] do
      resources :subscriptions,    only: [:create]
    end
  end

  get '/invite/:code',  to: "projects#index",     as: :invite
  get '/obrigado-de-coracao/:id', to: "subscribers#thanks", as: :thank_you
  root :to => 'projects#index'
end
