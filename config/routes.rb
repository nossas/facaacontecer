Selfstarter::Application.routes.draw do

  resources :projects,      only: [:index, :edit, :update] do
    resources :subscribers,  only: [:new, :create] do
      resources :subscriptions,    only: [:create]
    end
  end


  match '/nosso-muito-obrigado-de-coracao', to: "subscribers#thanks", via: :get, as: :thank_you
  root :to => 'projects#index'
end
