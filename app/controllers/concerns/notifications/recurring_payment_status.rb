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

      request_params = {
        :event      => param[:event],
        :id         => param[:resource][:id],
        :code       => param[:resource][:subscription_code],

        # Receiving a number from MOIP POST request and
        # mapping it a Payment state on the system.
        :state      => get_payment_state(param[:resource][:status][:code]),
      }

      return request_params
    end


  end

end
