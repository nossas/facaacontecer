module Notifications::RecurringPaymentStatus
  extend ActiveSupport::Concern


  # This is valid only for CREDITCARD 
  # payments.

  included do

    # HTTP POST from moip with
    # {
    #    "event": "payment.created",
    #    "date": "01/01/2013 00:00:00",
    #    "env": "sandbox",
    #    "resource": {
    #        "id": 6, //ID do pagamento
    #        "invoice_id": 13,
    #        "moip_id": 14456223,
    #        "subscription_code": "assinatura01",
    #        "amount": 101,
    #        "status": {
    #            "code": 2,
    #            "description": "Iniciado"
    #        },
    #        "payment_method": {
    #            "code": 1,
    #            "description": "Cartão de Crédito",
    #            "credit_card": { //enviado apenas se foi pago com cartão de crédito
    #                "brand": "VISA",
    #                "holder_name": "Fulano Testador",
    #                "first_six_digits": "411111",
    #                "last_four_digits": "1111",
    #                "vault": "cc7719e7-9543-4380-bdfe-c14d0e3b8ec9"
    #            }
    #        }
    #    }
    # }

    def payment_params(param)
      return false unless param[:resource]
      return false unless param[:event]
      
      return false unless (param[:event] =~ /^payment/).zero?

      request_params = {
        :event      => param[:event],
        :id         => param[:resource][:id].to_s,
        :code       => param[:resource][:subscription_code].to_s,

        # Receiving a number from MOIP POST request and
        # mapping it a Payment state on the system.
        :state      => get_payment_state(param[:resource][:status][:code].to_s),
      }

      return request_params
    end

    # Mapping all params received to the PaymentStatus concern
    def _params
      # Located @ app/controllers/concerns/notifications/payment_status
      puts params.inspect if Rails.env.production?
      return payment_params(params)
    end


  end

end
