module SubscriptionState 
  extend ActiveSupport::Concern
  
  # MAPPING ALL SUBSCRIPTIONS STATUSES
  #
  # Cycle between these status
  #   
  #   state :processing
  #   state :restarting
  #   state :errored

  #   Manual status (only admin can change)
  #   
  #   state :paused
  #   state :canceled

  #   Final status
  #   
  #   state :paid
  #   state :active

  included do

    state_machine initial: :waiting do

      event(:start) { transition :waiting => :processing } 

    end
  end
end
