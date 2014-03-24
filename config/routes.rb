Selfstarter::Application.routes.draw do

  root :to => 'projects#index'


  # Isolating subscription routes
  concern :subscriptable do
    member do 
      get :confirming
    end
  end



  
  resources :users, except: [:destroy, :update]
  resources :subscriptions, except: [:destroy], concerns: [:subscriptable]








  
  get '/invite/:code',                to: "projects#index",     as: :invite
  
  


end
