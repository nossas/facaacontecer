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
      if _params.has_key?(:id) 
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
        return @payment
      else
        raise "Subscription couldn't be found!"
      end
    end

end
