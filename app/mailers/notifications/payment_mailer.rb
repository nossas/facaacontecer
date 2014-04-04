# coding: utf-8
class Notifications::PaymentMailer < ActionMailer::Base 
  
  layout 'notifications/payment_mailer'

  default from: "Fernanda <fernanda@meurio.org.br>",
    bcc: "financiador@meurio.org.br",
    reply_to: "financiador@meurio.org.br"

  default_url_options[:protocol] = 'https://'
  default_url_options[:host] = 'apoie.meurio.org.br'



  # Email sent when a payment is created with URL and it's BOLETO
  def created_payment_slip(id)
    object(id)
    mail(
      to: @payment.user.email,
      subject: "[MeuRio] Seu boleto foi gerado!"
    )
  end


  def created_payment_debit(id)
    object(id)
    mail(
      to: @payment.user.email,
      subject: "[MeuRio] O link para a sua doação foi gerado!"
    )
  end

  def processing_payment(id)
    object(id)
    mail(
      to: @payment.user.email,
      subject: "[MeuRio] Seu pagamento está sendo processado!"
    )
  end

  def finished_payment(id)
    object(id)

    mail(
      to: @payment.user.email, 
      subject: "[MeuRio] Sua doação foi aprovada! É hora de festejar!"
    )

  end


  def cancelled_payment(id)
    object(id)

    mail(
      to: @payment.user.email,
      subject: "[MeuRio] Oops, houve um problema com a sua doação"
    )
  end


  def object(id)
    @payment = Payment.find_by(id: id)
  end
end
