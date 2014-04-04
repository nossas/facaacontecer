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
      event(:reverse)   do
        transition all - [:cancelled] => :reversed
      end

      # Event: Reembolsado (refund)
      event(:refund) do
        transition all - [:cancelled] => :refunded
      end

      # Event: Cancelado (cancelled by the payer)
      event(:cancel) do
        transition all - [:cancelled, :finished]  => :cancelled
      end

      # Event: Finished (payed)
      event(:finish) do 
        transition all - [:finished, :cancelled] => :finished
      end

    end

  end

end

