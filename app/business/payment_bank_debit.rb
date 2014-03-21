module PaymentBankDebit
  extend ActiveSupport::Concern




  included do

    # Available banks
    def available
      MyMoip::BankDebit::AVAILABLE_BANKS
    end

    # Build the payment Bank Debit request
    def payment_request 
      raise %Q{
        Missing "bank" definition, please 
        assign a subscription.debit.bank= using one of the following: #{available.inspect}
      } unless available.include?(bank.to_sym)

      bank_debit            = MyMoip::BankDebit.new(bank: bank.to_sym)
      bank_debit_payment    = MyMoip::BankDebitPayment.new(bank_debit)
      payment_request       = MyMoip::PaymentRequest.new(code)
      payment_request.api_call(bank_debit_payment, token: transparent_request.token)

      return payment_request
    end
    


  end

end
