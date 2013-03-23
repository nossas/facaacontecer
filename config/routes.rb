Selfstarter::Application.routes.draw do

  resources :projects,      only: [:index, :edit, :update] do
    resources :subscribers,  only: [:new, :create] do
      resources :subscriptions,    only: [:create]
    end
  end


  # Moip Webhooks/Notifications
  post 'webhooks/subscriptions', to: 'webhooks#subscription', as: :subscription_webhook

  get '/nosso-muito-obrigado-de-coracao', to: "subscribers#thanks", as: :thank_you
  root :to => 'projects#index'
end
