module PaymentObserver
  extend ActiveSupport::Concern



  included do
    before_create :setup_code

    # SETUP an unique code for each payment, after its creation
    # All subscriptions have only integer code
    # All payments have a PAYMENT suffix after the subscription code
    def setup_code
      self.code = "#{self.subscription.code}PAYMENT"
    end



    # After the finish event for a payment, activate the parent subscription
    # And send activated_subscription_email
    def activate_subscription 
      self.subscription.activate!
      Notifications::PaymentMailer.delay.finished_payment(self.id)
    end

    # After the Refund/ Reverse action in a payment, Pause the subscription
    # And send paused_subscription_email
    def pause_subscription
      self.subscription.pause!
    end



    # Placing all callbacks inside the observer, instead of 
    # Putting it on states file. This way we can keep things organized.
    # States where states should be; Callbacks (observers) where they should be as well.
    state_machine do
      after_transition on: :finish, do: :activate_subscription
      after_transition on: [:reverse, :refund], do: :pause_subscription
      after_transition on: :cancel, do: :pause_subscription
    end
  end

end
