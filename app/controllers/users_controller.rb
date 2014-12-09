class UsersController < ApplicationController

  before_actions do
    actions(:create) do
      @user = User.where(email: user_params[:email]).first_or_initialize(user_params)
    end
    actions(:edit)             { @user = User.find_by(id: params[:id]) }
  end

  force_ssl if: :ssl_configured?

  # GET /users
  def index; end

  # GET /users/new
  def new
    @organizations = Organization.order(:id)
    @organization_id = params[:organization_id] || @organizations.first.try(:id)
    @user = User.new(user_params)
    @user.subscriptions.build
  end

  # POST /users/
  def create

    case
      # If the user is a new user, try to save it
      when @user.new_record?
        @user.auth_token = SecureRandom.hex
        @user.id = (User.order(:id).last.try(:id) || 0) + 1
        @user.save

      # if the user has already an account (with its email)
      # try to update it
      when !@user.new_record?
        @user.try(:update_attributes, user_params)
    end

    # Render the form if errors are present in the user (update or save)
    return render :create if @user.errors.any?

    # Or redirect_to the subscription path if nothing wrong
    redirect_to subscription_path(Subscription.where(user_id: @user.id).order(:created_at).last)

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
                :subscriptions_attributes => [:value, :plan, :payment_option, :project_id, :bank, :organization_id]
      )
    else
      {}
    end
  end
end
