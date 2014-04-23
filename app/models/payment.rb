class Payment < ActiveRecord::Base
  include PaymentState
  include PaymentObserver
  include Mailchimped

  # Associations
  belongs_to :subscription

  # Access the subscription's user directly, using the subscription object
  delegate :user, to: :subscription


  # Validates the presence of these fields
  validates_presence_of :subscription

  def self.successful
    where("payments.state = 'finished' OR payments.state = 'authorized'")
  end
end
