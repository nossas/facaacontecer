class Notifications::PaymentMailer < ActionMailer::Base 

  default from: "Fernanda <fernanda@meurio.org.br>",
    bcc: "financiador@meurio.org.br",
    reply_to: "financiador@meurio.org.br"

  default_url_options[:host] = 'apoie.meurio.org.br'

  


  def finished_payment(id)
    object(id)

    mail(
      to: @payment.user.email, 
      subject: "Pagamento aprovado!"
    )

  end



  def object(id)
    @payment = Payment.find_by(id: id)
  end
end
