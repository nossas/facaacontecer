# coding: utf-8
class Subscription < ActiveRecord::Base

  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :subscriber, class_name: 'User'

  # Now we're recording payment instructions
  has_many :payment_instructions

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :subscriber_id, :interval, :payment_option
  
    
  # BITMASK options for subscription's intervals
  bitmask :interval, as: [:monthly, :biannual, :annual], null: false


  # TODO:
  # BITMASK options for subscription's payment_option
  # bitmask :payment_option, as: [:boleto, :cartao, :debito], null: false

  # Scope for completed payments
  scope :raised,     -> { where(status: :active).select('distinct subscriber_id') }
  scope :bankslips,  -> { where(payment_option: :boleto) }
  scope :creditcard, -> { where(payment_option: :creditcard) }
  scope :active,     -> { joins(:payment_instructions).where("payment_instructions.paid_at > ?", Time.now - 1.month) }


  # Saving the code
  before_validation :generate_unique_code


  # Generating a code based on the Current time in integer format
  def generate_unique_code
    self.code = Time.now.to_i 
  end






  # TODO: remove the code below.




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

  def create_payment_instruction(code, token, sequence)
    payment = PaymentInstruction.new do |p|
      p.status        = nil
      p.subscription  = self 
      p.expires_at    = nil
      p.code          = code
      p.expires_at    = Time.now + 10.days
      p.url           = MOIP_INSTRUCTION_URL + token
      p.sequence      = sequence
    end
    payment.save!
  end

  def send_payment_request(date, sequence)
    instruction = self.prepared_instruction 
    @transparent_request = MyMoip::TransparentRequest.new(self.code)
    @transparent_request.api_call(instruction)
    @payment = MyMoip::PaymentRequest.new(self.code)
    @payment.api_call(self.bankslip(expiration: date), token: @transparent_request.token)
    create_payment_instruction(instruction.id, @transparent_request.token, sequence) if @payment.success?
    @payment.success?
  end
end
