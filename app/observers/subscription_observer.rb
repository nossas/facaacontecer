module SubscriptionObserver
  extend ActiveSupport::Concern

  included do

    # Calling state_machine method to transit from created -> processing
    after_create :start!



    # Method to call the SubscriptionWorker
    # Where we perform the payment method using MyMoip
    # I was going to try observers, but lets keep using concerns.
    #


    # 
    # State machine callbacks
    # All callbacks calls should be inside the state_machine block
    #
    state_machine do
    end


  end

end
