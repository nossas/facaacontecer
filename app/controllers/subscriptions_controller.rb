class SubscriptionsController < ApplicationController
  before_actions do
    actions(:show, :confirm) { @subscription = Subscription.find_by(id: params[:id]) }
    actions(:show) { redirect_to payment_path(@subscription.payments.last) if @subscription.waiting? }
  end

  force_ssl if: :ssl_configured?


  # GET /subscriptions/:id
  def show; end


  # POST /subscriptions/:id/confirm
  def confirm
    @subscription.wait_confirmation
    render nothing: true
  end
end
