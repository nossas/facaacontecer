class SubscriptionsController < ApplicationController
  inherit_resources
  nested_belongs_to :project, :subscriber

  actions :create
  
  before_filter only: [:create] {  session[:subscriber_ok] = true }
  
  def create
    @subscription             = Subscription.new(params[:subscription])
    @subscription.project     = Project.find_by_id(params[:project_id])
    @subscription.subscriber  = User.find_by_id(params[:subscriber_id])
    create! { thank_you_path } 
  end


end
