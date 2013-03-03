class SubscribersController < ApplicationController
  inherit_resources
  defaults resource_class: User
  actions :new, :create 

  respond_to :html, only: :new
  respond_to :json, only: :create
  



  def create
    # FIXME: Belongs_to is not working here :/
    @project = Project.find(params[:project_id])

    # TODO: Remove duplicated code
    # The subscription url should not be duplicated and should be on the model
    if @subscriber = User.find_by_email_and_cpf(params[:user][:email], params[:user][:cpf])
      render json: @subscriber.as_json(
        subscription_url: project_subscriber_subscriptions_path(@project, @subscriber.id)
      )
    else
      create! do |success, failure|
        success.json { 
          render json: @subscriber.as_json(
            subscription_url: project_subscriber_subscriptions_path(@project, @subscriber.id)
          ) 
        }
      end
    end
  end


  def thanks
    redirect_to root_path unless session[:subscriber_ok]
  end
end
