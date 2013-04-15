# coding: utf-8
class Subscription < ActiveRecord::Base
 

  # Attributes accessible on create! or update! 
  attr_accessible :code, :value, :gift, :anonymous


  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :subscriber, class_name: 'User'

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :subscriber, :code

  # Scope for completed payments
  scope :raised, where(status: :active)


  def prepared_instruction
    instruction = MyMoip::InstructionRecurring.new(
        id: SecureRandom.hex(8),
        payment_reason: "Contribuição mensal para Meu Rio. Eu faço acontecer!",
        values: [self.value],
        payer: self.subscriber.as_payer,
        periodicity: 12
      )
    instruction
  end

  def bankslip
    MyMoip::BoletoPayment.new(expiration_days: 8, expiration_date: Time.now + 10.days)
  end
end
