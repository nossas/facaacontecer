module PaymentState 
  extend ActiveSupport::Concern



  # Mapping all payment states that moip can send
  # See app/controllers/notifications/payments_controller.rb
  #
  included do
    state_machine initial: :created do

      event(:start) do
        transition :created => :started 
      end

      event(:printing) do
        transition all - [:finished, :cancelled] => :printed
      end

      event(:authorize) do 
        transition all - [:finished, :cancelled] => :authorized
      end

      event(:wait) do 
        transition all - [:finished, :cancelled] => :waiting
      end

      # Event: Estorno (reverse)
      event(:reverse)   { transition all - [:cancelled] => :reversed   }

      # Event: Reembolsado (refund)
      event(:refund)    { transition all - [:cancelled] => :refunded   }


      event(:cancel)    { transition all - [:finished]  => :cancelled   }
      event(:finish)    { transition all - [:cancelled] => :finished    } 

    end

  end

end

