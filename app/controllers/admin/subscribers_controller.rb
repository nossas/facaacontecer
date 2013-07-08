class Admin::SubscribersController < ApplicationController
  layout 'admin'
  inherit_resources
  defaults resource_class: User

end
