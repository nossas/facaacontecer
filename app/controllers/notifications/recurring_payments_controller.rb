class Notifications::RecurringPaymentsController < ApplicationController

  # Located @ app/controllers/notifications/concerns/payment_status.rb
  include Notifications::PaymentStatus

  # Located @ app/controllers/notifications/concerns/recurring_payment_status.rb
  include Notifications::RecurringPaymentStatus

  respond_to :json

  # Find a payment or else, create one no matter what
  # (doing this due to retrocompatibility)
  before_actions do
    actions(:create) do
      if params[:event].match(/subscription/)
        update_subscription_state params[:resource][:code], params[:resource][:status], params[:event]
      elsif _params.has_key?(:id)
        @payment = Payment.find_by(code: _params[:id])
        build_payment if @payment.nil?
      else
        render_nothing_with_status(401)
      end
    end
  end

  private

  # Building a payment when a subscription is found
  def build_payment
    @subscription = Subscription.find_by(code: _params[:code])
    if @subscription.present?

      # Create a payment with the params from moip webhook
      @payment = @subscription.payments.create!(url: nil)

      # Update @payment because the CODE attribute is automatically generate on Create
      @payment.update_attributes!(code: _params[:id])
    else
      raise "Subscription couldn't be found!"
    end
  end

  def update_subscription_state code, status, event
    subscription = Subscription.find_by_code(code)
    if event == "subscription.created" || event == "subscription.updated"
      subscription.update_attribute :state, status.downcase
    elsif event == "subscription.suspended"
      subscription.update_attribute :state, "suspended"
    elsif event == "subscription.activated"
      subscription.update_attribute :state, "active"
    elsif event == "subscription.canceled"
      subscription.update_attribute :state, "canceled"
    end
  end
end
