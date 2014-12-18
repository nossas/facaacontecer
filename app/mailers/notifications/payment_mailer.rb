# coding: utf-8
class Notifications::PaymentMailer < ActionMailer::Base

  layout 'notifications/payment_mailer'

  default from: "Fernanda <fernanda@nossascidades.org>", reply_to: "fernanda@nossascidades.org"

  default_url_options[:host] = 'apoie.meurio.org.br'

  def created_payment_slip(id)
    @payment = Payment.find(id)
    @user = @payment.subscription.user
    mail(
      to: @payment.user.email,
      subject: "Seu boleto foi gerado!"
    )
  end

  def created_payment_debit(id)
    @payment = Payment.find(id)
    @user = @payment.subscription.user
    mail(
      to: @payment.user.email,
      subject: "O link para a sua doação foi gerado!"
    )
  end

  def processing_payment(id)
    @payment = Payment.find(id)
    @user = @payment.subscription.user
    mail(
      to: @payment.user.email,
      subject: "Seu pagamento está sendo processado!"
    )
  end

  def authorized_payment(id)
    @payment = Payment.find(id)
    @user = @payment.subscription.user
    mail(
      to: @payment.user.email,
      subject: "Que lindo, sua doação foi aprovada!"
    )
  end

  def cancelled_payment(id)
    @payment = Payment.find(id)
    @user = @payment.subscription.user
    mail(
      to: @payment.user.email,
      subject: "Oops, houve um problema com a sua doação"
    )
  end
end
