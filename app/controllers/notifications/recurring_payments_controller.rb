class Notifications::RecurringPaymentsController < ApplicationController 
 
  # Located @ app/controllers/notifications/concerns/payment_status.rb
  include Notifications::PaymentStatus
  
  # Located @ app/controllers/notifications/concerns/recurring_payment_status.rb
  include Notifications::RecurringPaymentStatus
  

  # Find a payment or else, create one no matter what 
  # (doing this due to retrocompatibility)
  before_actions do
    actions(:create) do
      @payment = Payment.find_by(code: _params[:id])
      if @payment.nil?
        build_payment
      end
    end
  end




  private 
    # Building a payment when a subscription is found 
    def build_payment
      @subscription = Subscription.find_by(code: _params[:code])
      if @subscription.present?
        @payment = @subscription.payments.create!(url: nil)
        @payment.update_attributes!(code: _params[:id])
        @payment
      else
        raise "Subscription couldn't be found!"
      end
    end

end
