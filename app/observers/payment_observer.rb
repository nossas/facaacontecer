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
    def activate_subscription 
      self.subscription.activate!
    end



    # Placing all callbacks inside the observer, instead of 
    # Putting it on states file. This way we can keep things organized.
    # States where states should be; Callbacks (observers) where they should be as well.
    state_machine do
      after_transition on: :finish, do: :activate_subscription
    end
  end

end
