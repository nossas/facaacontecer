# Initializing module
module Business
  module Payer
    include Subscriber
  end

  module Slip 
    include Payment
    include PaymentSlip
  end

  module BankDebit
    include Payment
    include PaymentBankDebit
  end
end
