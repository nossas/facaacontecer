class OrdersController < ApplicationController
  
  inherit_resources
  belongs_to :project
  
  before_filter only: [:show] do
    unless params[:secure] == session[:secure]
      redirect_to root_path
    end
  end


  def create 
    session[:secure] = SecureRandom.hex(32)
    create! do |success, failure|
      success.html { redirect_to project_order_path(@project, @order, secure: session[:secure]) }
      failure.html { render :new }
    end
  end


  def prefill

    @instruction = nil
    @order = Order.prefill!(params[:order])

    # This is where all the magic happens. We create a multi-use token with MoIP, letting us charge the user's account 
    # if its payment option was recurring.

  end

  def share
    @order = Order.find_by_uuid(params[:uuid])
  end
end
