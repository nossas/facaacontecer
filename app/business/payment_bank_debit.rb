module PaymentBankDebit
  extend ActiveSupport::Concern




  included do
    # Setting the bank
    def bank=(bank)
      @bank = available.include?(bank) ? bank : false 
    end
 
    def bank
      return @bank
    end

    # Available banks
    def available
      MyMoip::BankDebit::AVAILABLE_BANKS
    end

    # Build the payment Bank Debit request
    def payment_request 
      raise %Q{
        Missing "bank" definition, please 
        assign a subscription.debit.bank= using one of the following: #{available.inspect}
      } unless bank

      bank_debit            = MyMoip::BankDebit.new(bank: bank)
      bank_debit_payment    = MyMoip::BankDebitPayment.new(bank_debit)
      payment_request       = MyMoip::PaymentRequest.new(code)
      payment_request.api_call(bank_debit_payment, token: transparent_request.token)

      return payment_request
    end
    


  end

end
