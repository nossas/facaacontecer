# Initializing module
module Business
  module Payer
    include SubscriberBusiness
  end

  module Slip 
    include PaymentBusiness
    include PaymentSlipBusiness
  end

  module BankDebit
    include PaymentBusiness
    include PaymentBankDebitBusiness
  end
end
