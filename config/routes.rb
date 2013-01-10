Selfstarter::Application.routes.draw do



  resources :projects,      only: [:index, :edit, :update] do
    resources :supporters,  only: [:new, :create], controller: :users do
      resources :orders,    only: [:new, :create]
    end
  end


 # get   '/preorder'                 => 'preorder#index',    as: :preorder
  #get   '/preorder/checkout',                               as: :checkout
  #get   '/preorder/share/:uuid'     => 'preorder#share',    as: :share
  #post  '/preorder/ipn'             => 'preorder#ipn',      as: :ipn
  #match '/preorder/prefill'         => 'preorder#prefill',  as: :prefill
  #match '/preorder/postfill'        => 'preorder#postfill', as: :postfill 

  root :to => 'projects#index'
end
