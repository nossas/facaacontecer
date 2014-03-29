module Notifications::PaymentStatus
  extend ActiveSupport::Concern



  # This is valid only for SLIP (Boleto) and DEBIT (Débito)
  # payments.

  included do

    # See:
    # https://labs.moip.com.br/parametro/statuspagamento/
    # 1 - Autorizado
    # 2 - Iniciado
    # 3 - BoletoImpresso
    # 4 - Concluído
    # 5 - Cancelado
    # 6 - EmAnalise
    # 7 - Estornado
    # 9 - Reembolsado
    def get_payment_state(code)
      statuses = { 
        "1" => "authorize", # Autorizado, but not yet in the MOIP account
        "2" => "start",     # Payment started
        "3" => "printing",  # Slip only
        "4" => "finish",    # Finalizada, which means money in the pocket (MOIP ACCOUNT)
        "5" => "cancel",    # Cancelada by the payer
        "6" => "wait",      # Awaiting confirmation
        "7" => "reverse",   # Estornado
        "9" => "refund"     # Reembolsado
      }

      return statuses[code.to_s] 
    end



    # HTTP POST from moip with
    # {
    #   id_transacao => abc.1234
    #   valor => 100
    #   status_pagamento => 5
    #   cod_moip => 12345678
    #   forma_pagamento => 3
    #   tipo_pagamento => CartaoDeCredito
    #   parcelas => 1
    #   email_consumidor => pagador@email.com.br
    #   classificacao => Solicitado pelo vendedor
    # }
    def payment_params(param)
      return false unless param[:id_transacao]

      request_params = { 
        :payment_type    => param[:tipo_pagamento],
        :code            => param[:id_transacao],
        :value           => param[:valor],

        # Receiving a number from MOIP POST request and
        # mapping it a Payment state on the system.
        :state           => get_payment_state(param[:status_pagamento]),


        :id              => param[:cod_moip],
        :user            => param[:email_consumidor],
        :payment_type    => param[:forma_pagamento]
      }

      return request_params
    end


  end

end
