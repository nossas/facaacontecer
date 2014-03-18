# Initializing module
module Business
  module Payer
    include Subscriber
  end

  module Slip 
    include PaymentSlip
  end

  module BankDebit
    include PaymentBankDebit
  end
end
