class UsersController < ApplicationController

  before_actions do 

    actions(:new)              { @user = User.new(user_params) }
    actions(:create) do 
      @user = User.where(email: user_params[:email]).first_or_initialize(user_params)
    end
    actions(:new)              { @user.subscriptions.build }
    actions(:edit)             { @user = User.find_by(id: params[:id]) }
  end

  force_ssl if: :ssl_configured?

  # GET /users
  def index; end

  # GET /users/new
  def new; end


  # POST /users/
  def create 

    case 
    when @user.new_record?
      @user.save 
    when !@user.new_record?
      @user.try(:update_attributes, user_params)
    end
    
   
    return render :new if @user.errors.any?
    redirect_to subscription_path(@user.subscriptions.last)
    
  end


    private
    # Checking for user params on request
    def user_params 
      if params[:user]
        params.require(:user).permit(
          %i(first_name last_name email cpf birthday 
                postal_code address_street address_extra 
                address_number address_district city state 
                phone country), 
                :subscriptions_attributes => [:value, :plan, :payment_option, :project_id, :bank]
        )
      else
        {}
      end
    end
  end
