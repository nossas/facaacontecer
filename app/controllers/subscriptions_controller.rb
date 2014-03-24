class SubscriptionsController < ApplicationController
  before_actions do
    actions(:show) { @subscription = Subscription.find_by(id: params[:id]) }
    actions(:show) { redirect_to payment_path(@subscription.payments.last) if @subscription.waiting? }
  end


  # GET /subscriptions/:id
  def show; end
end
