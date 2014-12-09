# coding: utf-8
class Subscription < ActiveRecord::Base

  # located @ app/states/
  # include SubscriptionState

  # This file holds all CALLBACKS that belongs to subscription's objects
  # located @ app/observers/
  include SubscriptionObserver
  include Mailchimped

  # Allowed subscription plans & Allowed payment options
  ALLOWED_PLANS     = %w(monthly biannual annual)
  ALLOWED_PAYMENTS  = %w(debit slip creditcard)
  ALLOWED_BANKS     = %w(banco_do_brasil bradesco banrisul itau)

  # Relationship with Projects and the correspondent user for each subscription
  belongs_to :project, inverse_of: :subscriptions
  belongs_to :user, inverse_of: :subscriptions
  belongs_to :organization

  # Now we're recording payment instructions
  has_many :payments

  # And now we're recording invoices
  has_many :invoices

  # This attributes should be present when creating an order
  validates_presence_of :value, :project, :user, :payment_option, :plan

  # We only need the bank account if the payment option is debit
  validates_presence_of :bank, if: -> { debit? }

  # Check if the payment_option is in the allowed payments
  validates_inclusion_of :plan, in: ALLOWED_PLANS, allow_blank: false, allow_nil: false
  validates_inclusion_of :payment_option, in: ALLOWED_PAYMENTS, allow_blank: false, allow_nil: false


  # Allowing nil or blank when payment_option is creditcard
  validates_inclusion_of :bank, in: ALLOWED_BANKS, allow_blank: true, allow_nil: true

  validates_uniqueness_of :code

  def creditcard?
    self.payment_option == 'creditcard'
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

  def waiting?
    state == "waiting"
  end

  def processing?
    state == "processing"
  end

  def wait_confirmation!
    self.update_attribute :state, "waiting"
  end

  # TODO perhaps we should create an invoices table and integrate
  def successful_invoices
    api = Moip::Invoice.new
    api.subscription_code = self.code
    api.invoices.select{|i| i["status"]["code"] == 3}
  end

  # TODO we definitely have to create an invoices table
  def last_successful_invoice_date
    last_invoice = successful_invoices.last
    Date.new(last_invoice["creation_date"]["year"],
             last_invoice["creation_date"]["month"],
             last_invoice["creation_date"]["day"]) if last_invoice.present?
  end
end
