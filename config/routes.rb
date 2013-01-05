Selfstarter::Application.routes.draw do


  resources :projects, except: [:new, :create, :destroy, :show] do
    resources :orders, except: [:index, :destroy]
  end


 # get   '/preorder'                 => 'preorder#index',    as: :preorder
  #get   '/preorder/checkout',                               as: :checkout
  #get   '/preorder/share/:uuid'     => 'preorder#share',    as: :share
  #post  '/preorder/ipn'             => 'preorder#ipn',      as: :ipn
  #match '/preorder/prefill'         => 'preorder#prefill',  as: :prefill
  #match '/preorder/postfill'        => 'preorder#postfill', as: :postfill 

  root :to => 'projects#index'
end
