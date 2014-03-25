module Notifications::PaymentStatus
  extend ActiveSupport::Concern



  # This is valid only for SLIP (Boleto) and DEBIT (Débito)
  # payments.

  included do


    # See:
    # https://labs.moip.com.br/parametro/statuspagamento/
    def get_payment_state(code)
      statuses = { 
        "1" => "authorize",  # Autorizado, but not yet in the MOIP account
        "2" => "start",     # Payment started
        "3" => "print",     # Slip only
        "4" => "finish",    # Finalizada, which means money in the pocket (MOIP ACCOUNT)
        "5" => "cancel",   # Cancelada by the payer
        "6" => "wait",     # Awaiting confirmatino
        "7" => "reverse",    # Estornado
        "8" => "refund"     # Reembolsado
      }

      return statuses[code.to_s] 
    end


    def payment_params(param)
      return false unless param[:id_transacao]


      request_params = { 
        :payment_type    => param[:tipo_pagamento],
        :code            => param[:id_transacao],
        :value           => param[:valor],
        :state           => get_payment_state(param[:status_pagamento]),
        :id              => param[:cod_moip],
        :user            => param[:email_consumidor],
        :payment_type    => param[:forma_pagamento]
      }

      return request_params
    end




  end

end
