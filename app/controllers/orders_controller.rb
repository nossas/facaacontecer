class OrdersController < ApplicationController
  
  inherit_resources
  belongs_to :project
  respond_to :json, only: [:create]


  before_filter only: [:show] do
    unless params[:secure] == session[:secure]
      redirect_to root_path
    end
  end


  def create 
    create! do |success, failure|
      success.json do 
        @order.generate_payment_token!
        render json: { order: @order.as_json({ token: @order.token }) } 
      end
      failure.json { render json: { order: @order.errors }, status: :accepted }
    end
  end
end
