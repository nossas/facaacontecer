class UsersController < ApplicationController

  before_actions do 

    actions(:new, :create)     { @user = User.new(user_params) }
    actions(:new)     { @user.subscriptions.build }
    actions(:edit)    { @user = User.find_by(id: params[:id]) }
  end

  # GET /users
  def index; end

  # GET /users/new
  def new; end


  # POST /users/
  def create 
    if @user.save
      redirect_to subscription_path(@user.subscriptions.last)
    else
      render :new
    end
  end

  private
  def user_params 
    # Checking for user params on request
    if params[:user]
      params.require(:user).permit(
        %i(first_name last_name email cpf birthday 
              zipcode address_street address_extra 
              address_number address_district city state 
              phone country), 
              :subscriptions_attributes => [:value, :plan, :payment_option, :project_id, :bank]
      )
    else
      {}
    end
  end
end
