class SubscriptionsController < ApplicationController
  before_actions do
    actions(:show, :confirm) { @subscription = Subscription.find_by(id: params[:id]) }
    actions(:show) { redirect_if_not_creditcard }
  end

  force_ssl if: :ssl_configured?


  # GET /subscriptions/:id
  def show; end


  # POST /subscriptions/:id/confirm
  def confirm
    @subscription.wait_confirmation
    render nothing: true
  end

  
  # Redirects
  def redirect_if_not_creditcard
    # If the subscription is waiting and it's SLIP or DEBIT
    if @subscription.waiting? && !@subscription.creditcard?
      redirect_to payment_path(@subscription.payments.last)

    # But if it's creditcard, redirect it already
    elsif @subscriptions.payments.last.present? && @subscription.creditcard?
      redirect_to payment_path(@subscription.payments.last) 
    end
  end
end
