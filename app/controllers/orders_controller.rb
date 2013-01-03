class OrdersController < ApplicationController
  
  inherit_resources
  belongs_to :project


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
