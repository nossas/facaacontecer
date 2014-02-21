class Admin::SubscribersController < ApplicationController
  layout 'admin'


  before_filter do
    redirect_to admin_sessions_path unless session[:admin] == true
  end

  def bank_slips; end
  def payment_instructions; end
end
