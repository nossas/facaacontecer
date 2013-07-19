class Admin::SubscribersController < ApplicationController
  layout 'admin'
  inherit_resources
  defaults resource_class: User


  before_filter do
    redirect_to admin_sessions_path unless session[:admin] == true
  end

  def bank_slips; end
  def payment_instructions; end
end
