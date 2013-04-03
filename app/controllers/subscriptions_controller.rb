class SubscriptionsController < ApplicationController
  inherit_resources
  actions :create
 
  after_filter  only: [:create] {  session[:subscriber_ok] = true }
  after_filter  only: [:create] do
    SubscriptionMailer.successful_create_message(@subscription.id)
    if @subscription.subscriber.invite.host.present?
      SubscriptionMailer.inviter_friend_subscribed(@subscription.id)
    end
  end


  def create
    @subscription             = Subscription.new(params[:subscription])
    @subscription.project     = Project.find(params[:project_id])
    @subscription.subscriber  = User.find(params[:subscriber_id])
    @subscription.status      = 'active'
    create! { thank_you_path(@subscription.subscriber) } 
  end


end
