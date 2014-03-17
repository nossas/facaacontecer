Selfstarter::Application.routes.draw do

  root :to => 'projects#index'
  
  resources :users, except: [:destroy]






  
  get '/invite/:code',                to: "projects#index",     as: :invite
  get '/obrigado-de-coracao/:id',     to: "subscribers#thanks", as: :thank_you
  
  

  get   '/boletos',                   to: "webhooks#bankslips"
  post  '/boletos/status',            to: 'webhooks#status'
  post  '/subscriptions/status',      to: 'webhooks#subscription_status'



#  namespace :admin do
    #resources :sessions, only: [:index, :create]
    #resources :subscribers do 
      #collection do
        #get :bank_slips
        #get :payment_instructions
      #end
    #end
  #end

end
