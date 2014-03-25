module PaymentState 
  extend ActiveSupport::Concern



  # Mapping all payment states that moip can send
  # See app/controllers/notifications/payments_controller.rb
  #
  included do
    state_machine initial: :created do

      event(:start)     { transition :created => :started }
      event(:print)     { transition all - [:finished, :cancelled] => :printed    }
      event(:authorize) { transition all - [:finished, :cancelled] => :authorized }
      event(:wait)      { transition all - [:finished, :cancelled] => :waiting    }

      # Event: Estorno (reverse)
      event(:reverse)   { transition all - [:cancelled] => :reversed   }

      # Event: Reembolsado (refund)
      event(:refund)    { transition all - [:cancelled] => :refunded   }


      event(:cancel)    { transition all - [:finished]  => :cancelled   }
      event(:finish)    { transition all - [:cancelled] => :finished    } 

    end

  end

end

