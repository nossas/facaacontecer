module SubscriptionState 
  extend ActiveSupport::Concern
  
  # MAPPING ALL SUBSCRIPTIONS STATUSES
  #
  #   => Initial states
  #   
  #   state :created
  #   state :processing
  #
  #   --------------
  #   => Notifications
  #
  #   state :waiting
  #   state :active
  #   state :canceled
  #   state :errored
  #
  #   ---------------
  #   => Manual status (only admin can change)
  #   
  #   state :paused
  #   state :canceled
  #
  #   ----------------
  #   => Final status
  #   
  #   state :paid
  #   state :active

  included do

    state_machine initial: :created do

      event(:start) { transition :created => :processing } 
      event(:wait_confirmation) { transition :processing => :waiting }
    end
  end
end
