module Business::Payment


  included do

    # Default instruction object
    def instruction 
      MyMoip::Instruction.new(
        id:             code,
        payment_reason: "Doação para o MeuRio - http://meurio.org.br - #{payment_option}",
        values:         [value],
        payer:          user.business.build_payer
      )
    end

    # Build a transparent request to moip server
    def transparent_request
      transparent = MyMoip::TransparentRequest.new(code)
      transparent.api_call(instruction)

      return transparent
    end


    # Return the PAYMENT URL (Boleto, Debito) url
    def url
      # Payment_Request is implemented on each PaymentMethod class
      payment_request.url
    end
  


  end
end
