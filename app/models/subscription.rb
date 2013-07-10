# coding: utf-8
class Subscription < ActiveRecord::Base
 

  # Attributes accessible on create! or update! 
  attr_accessible :code, :value, :gift, :anonymous, :status


  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :subscriber, class_name: 'User'

  # Now we're recording payment instructions
  has_many :payment_instructions

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :subscriber, :code

  # Scope for completed payments
  scope :raised,      where(status: :active).select('distinct subscriber_id')
  scope :bankslips,   where(payment_option: :boleto)
  scope :creditcard,  where(payment_option: :creditcard)


  def prepared_instruction
    instruction = MyMoip::Instruction.new(
        id: SecureRandom.hex(8),
        payment_reason: "Contribuição mensal para Meu Rio. Eu faço acontecer!",
        values: [self.value],
        payer: self.subscriber.as_payer,
      )
    instruction
  end

  def bankslip(options = {})
    return unless options[:expiration]
    MyMoip::BoletoPayment.new(expiration_date: options[:expiration], expiration_days: 14)
  end
end
