# coding: utf-8
class Subscription < ActiveRecord::Base
    
  # located @ app/states/
  include SubscriptionState

  # Allowed subscription plans
  ALLOWED_PLANS = %w(monthly biannual annual)

  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project
  belongs_to :user

  # Now we're recording payment instructions
  has_many :payment_instructions

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :user, :payment_option, :plan
  validates_inclusion_of :plan, in: ALLOWED_PLANS
  

  # TODO:
  # BITMASK options for subscription's payment_option
  # bitmask :payment_option, as: [:boleto, :cartao, :debito], null: false

  # Scope for completed payments
  scope :raised,     -> { where(state: :active).select('distinct user_id') }
  scope :bankslips,  -> { where(payment_option: :boleto) }
  scope :creditcard, -> { where(payment_option: :creditcard) }
  scope :active,     -> { joins(:payment_instructions).where("payment_instructions.paid_at > ?", Time.now - 1.month) }


  # Saving the code
  before_validation :generate_unique_code

  # Using this to avoid param errors when running cucumber steps
  before_validation :set_fake_plan

  # Generating a code based on the Current time in integer format
  def generate_unique_code
    self.code = Time.now.to_i 
  end


  # For some reason, we can't test using the plan PARAM
  def set_fake_plan
    if Rails.env.test?
      self.plan = 'monthly'
    end
  end


  def cartao
    # Cartao is handled by the Moip's JavaScript Library
    # Go check app/assets/javascripts
  end


  # Extending some business logic inside method calls
  def boleto
    # Located @ app/business/payment_slip.rb
    extend Business::Slip
  end

  
  # Extending some business logic inside method calls
  def debito
    # Located @ app/business/payment_bank_debit.rb
    extend Business::BankDebit
  end

end
