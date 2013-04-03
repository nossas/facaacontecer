class SubscriptionsController < ApplicationController
  inherit_resources
  actions :create
 
  after_filter  only: [:create] {  session[:subscriber_ok] = true }
  after_filter  only: [:create] {  SuckerPunch::Queue[:mail].async.perform(@subscription.id) }


  def create
    @subscription             = Subscription.new(params[:subscription])
    @subscription.project     = Project.find(params[:project_id])
    @subscription.subscriber  = User.find(params[:subscriber_id])
    @subscription.status      = 'active'
    create! { thank_you_path(@subscription.subscriber) } 
  end


end
