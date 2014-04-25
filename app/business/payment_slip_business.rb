module PaymentSlipBusiness
  extend ActiveSupport::Concern

  included do

    # Build the payment slip request
    def payment_request
      payment_slip_payment = MyMoip::PaymentSlipPayment.new
      payment_request      = MyMoip::PaymentRequest.new("#{code}_#{self.payments.count}_PAYMENT")
      payment_request.api_call(payment_slip_payment, token: transparent_request.token)

      return payment_request
    end

  end


end
