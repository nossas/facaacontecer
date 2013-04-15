class SubscribersController < InheritedResources::Base
  defaults resource_class: User
  actions :new, :create 

  respond_to :html, only: :new
  respond_to :json, only: :create
  
  # If the subscription process was complete, we set a session key to show the thanks page
  # Just because we don't other people to see if they aren't subscribers yet.
  before_filter only: [:thanks] { redirect_to root_path unless session[:subscriber_ok] }
  before_filter only: [:thanks, :bankslip_thanks] { @subscriber = User.find_by_id(params[:id]) }



  # Creating a subscriber based on a project
  def create
    # This is need because for some reason, inherited resources is not working. 
    @project  = Project.find(params[:project_id])

    return if @project.nil?

    # If the user already subscribed, just give to him his subscription url.
    if @subscriber = User.find_by_email_and_cpf(params[:user][:email], params[:user][:cpf])
      return subscriber_subscription_url 
    end

    # If no subscriber was found, move on and create it. 
    create! do |success, failure|
      success.json do 
        associate_invite
        subscriber_subscription_url 
      end
    end
  end

  # After subscription, this will be the users' path
  def thanks; end
  def bankslip_thanks; end

  protected 
    # Associate invite, if present
    def associate_invite
      if session[:invite]
        invite ||= Invite.find_by_code(session[:invite])
        if invite.present?
          @subscriber.invite.update_attributes!(parent_user_id: invite.user_id)
          session[:invite] = nil
        end
      end
    end
    
    # Common render action for both existing users and new users
    def subscriber_subscription_url
      render json: @subscriber.as_json(
        subscription_url: project_subscriber_subscriptions_path(@project, @subscriber.id),
        boleto_subscription_url: bank_slip_project_subscriber_subscriptions_path(@project, @subscriber.id) # For boleto users
      ) 
    end
end
