class SubscribersController < ApplicationController

  before_actions do 
    # Object actions
    actions(:create)        do 
      @project = Project.find_by(id: params[:project_id])
      check_subscriber_constraints
    end

    actions(:new, :create)  { @subscriber = User.new(subscriber_params) }

    # Member actions
    actions(:show, :update, :edit, :thanks) { @subscriber = User.find_by(id: params[:id]) }
  end

  # POST /subscribers/
  def create
    if @subscriber.save
      associate_invite
      render json: subscriber_subscription_urls
    end
  end

  # PUT /subscribers/:id
  def update; end

  
  # GET /obrigado/:id
  def thanks
    redirect_to root_path unless session[:subscriber_ok]
  end


  private
    def subscriber_params
      # Checking for user params on request
      if params[:user]
        params.require(:user).permit(
        %i(first_name last_name email cpf birthday 
            postal_code address_street address_extra 
            address_number address_district city state 
            phone country))
      else
        {}
      end
    end
  

    def check_subscriber_constraints
      # If the user already subscribed, just give to him his subscription url.
      if @subscriber = User.find_by(email: params[:user][:email])
        return subscriber_subscription_url 
      end   
    end

    # Associate invite, if present
    def associate_invite
      if session[:invite]
        invite ||= Invite.find_by(code: session[:invite])
        if invite.present?
          @subscriber.invite.update_attributes!(parent_user_id: invite.user_id)
          session[:invite] = nil
        end
      end
    end
    
    # Common render action for both existing users and new users
    def subscriber_subscription_urls
      @subscriber.as_json(
        subscription_url: project_subscriber_subscriptions_path(@project, @subscriber.id),
        boleto_subscription_url: bank_slip_project_subscriber_subscriptions_path(@project, @subscriber.id) # For boleto users
      ) 
    end




end
