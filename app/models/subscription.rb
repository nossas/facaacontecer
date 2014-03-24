# coding: utf-8
class Subscription < ActiveRecord::Base

  # located @ app/states/
  include SubscriptionState


  # This file holds all CALLBACKS that belongs to subscription's objects
  # located @ app/observers/
  include SubscriptionObserver



  # Allowed subscription plans & Allowed payment options
  ALLOWED_PLANS     = %w(monthly biannual annual)
  ALLOWED_PAYMENTS  = %w(debit slip creditcard) 
  ALLOWED_BANKS     = %w(banco_do_brasil bradesco banrisul itau)

  # Relationship with Projects and the correspondent user for each subscription 
  belongs_to :project, inverse_of: :subscriptions
  belongs_to :user, inverse_of: :subscriptions

  # Now we're recording payment instructions
  has_many :payments

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :user, :payment_option, :plan
  
  # We only need the bank account if the payment option is debit
  validates_presence_of :bank, if: -> { debit? }

  # Check if the payment_option is in the allowed payments
  validates_inclusion_of :plan, in: ALLOWED_PLANS
  validates_inclusion_of :payment_option, in: ALLOWED_PAYMENTS


  # Allowing nil or blank when payment_option is creditcard
  validates_inclusion_of :bank, in: ALLOWED_BANKS, allow_blank: true, allow_nil: true
  

  # Scope for completed payments
  scope :raised,     -> { where(state: :active).select('distinct user_id') }
  scope :bankslips,  -> { where(payment_option: :boleto) }
  scope :creditcard, -> { where(payment_option: :creditcard) }
  scope :active,     -> { joins(:payments).where("payments.paid_at > ?", Time.now - 1.month) }


  # Saving the code
  before_validation :generate_unique_code

  # Generating a code based on the Current time in integer format
  def generate_unique_code
    self.code = Time.now.to_i 
  end

  def debit?
    self.payment_option == 'debit'
  end

  def slip?
    self.payment_option == 'slip'
  end

  def cartao
    # Cartao is handled by the Moip's JavaScript Library
    # Go check app/assets/javascripts
  end


  # Extending some business logic inside method calls
  def boleto
    return false unless payment_option == 'slip'
    # Located @ app/business/payment_slip_business.rb
    extend Business::Slip
  end

  
  # Extending some business logic inside method calls
  def debito
    return false unless payment_option == 'debit'
    # Located @ app/business/payment_bank_debit_business.rb
    extend Business::BankDebit
  end

end
