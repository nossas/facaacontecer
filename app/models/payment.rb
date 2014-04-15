class Payment < ActiveRecord::Base


  # Located @ app/states/payment_state.rb
  include PaymentState

  # Located @ app/observers/payment_observer.rb
  include PaymentObserver

  # Associations
  belongs_to :subscription

  # Access the subscription's user directly, using the subscription object
  delegate :user, to: :subscription


  # Validates the presence of these fields
  validates_presence_of :subscription

  def self.successful
    where("state = 'finished' OR state = 'authorized'")
  end
end
