class Admin::SessionsController < ApplicationController
  layout 'admin'

  before_filter do 
    redirect_to admin_subscribers_path if session[:admin] == true
  end

  def index; end
  def create
    if params[:admin_key] == ENV['ADMIN_UNIQUE_KEY']
      session[:admin] = true
      return redirect_to admin_subscribers_path
    end
    
    
    render :index
  end

end
