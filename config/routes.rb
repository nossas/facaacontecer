Selfstarter::Application.routes.draw do

  get   '/preorder'                 => 'preorder#index',    as: :preorder
  get   '/preorder/checkout',                               as: :checkout
  get   '/preorder/share/:uuid'     => 'preorder#share',    as: :share
  post  '/preorder/ipn'             => 'preorder#ipn',      as: :ipn
  match '/preorder/prefill'         => 'preorder#prefill',  as: :prefill
  match '/preorder/postfill'        => 'preorder#postfill', as: :postfill 

  root :to => 'preorder#index'
end
