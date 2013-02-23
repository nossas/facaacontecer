Selfstarter::Application.routes.draw do

  resources :projects,      only: [:index, :edit, :update] do
    resources :supporters,  only: [:new, :create], controller: :users do
      resources :subscriptions,    only: [:create]
    end
  end


  root :to => 'projects#index'
end
