module SubscriptionObserver
  extend ActiveSupport::Concern

  included do

    # Calling state_machine method to transit from created -> processing
    # after_create :start!

    # TODO it should run only when state changes
    after_save do
      self.delay.add_to_subscription_segment(self.user.email, self.state)
    end

    # Method to call the SubscriptionWorker
    # Where we perform the payment method using MyMoip
    # I was going to try observers, but lets keep using concerns.
    #


    #
    # State machine callbacks
    # All callbacks calls should be inside the state_machine block
    #
    # state_machine do
    # end

    # Saving the code
    before_create { self.code = "#{self.user_id}_#{Time.now.to_i}" }
  end
end
