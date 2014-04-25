module PaymentBusiness
  extend ActiveSupport::Concern

  included do

    # Default instruction object
    def instruction
      MyMoip::Instruction.new(
        # generate an unique identifier for this instruction
        # adding _payment suffix to it.
        id:             "#{code}_#{self.payments.count}_PAYMENT",
        payment_reason: "Doação para o MeuRio - http://meurio.org.br",
        values:         [value],
        payer:          user.business.build_payer,
        #return_url:    '',
        #notification_url: Rails.application.routes.url_helpers.notifications_payments_url(host: MOIP_NOTIFICATIONS_HOST),
      )
    end

    # Build a transparent request to moip server
    def transparent_request
      transparent = MyMoip::TransparentRequest.new(code)
      transparent.api_call(instruction)

      return transparent
    end


    # Payment Request status
    def success?
      payment_request.success?
    end


    # Return the PAYMENT URL (Boleto, Debito) url
    def url
      # Payment_Request is implemented on each PaymentMethod class
      payment_request.url
    end


    def token
      # Getting the token for boleto/debito
      payment_request.token
    end


  end
end
