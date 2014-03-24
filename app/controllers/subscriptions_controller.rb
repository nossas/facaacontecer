class SubscriptionsController < ApplicationController
  before_actions do
    actions(:show, :edit, :confirming) { @subscription = Subscription.find_by(id: params[:id]) }
    actions(:show) { redirect_to confirming_subscription_path(@subscription) if @subscription.waiting? }
  end


  # GET /subscriptions/:id
  def show; end


  # GET /subscriptions/:id/confirming
  def confirming; end
end
