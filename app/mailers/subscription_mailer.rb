class SubscriptionMailer < ActionMailer::Base
  default from: "Leonardo do Meu Rio <contato@apoie.meurio.org.br>"


  def successful_create_message(subscriber)
    @subscriber = subscriber
    mail(to: subscriber.email, subject: "Obrigado por financiar o Meu Rio!")
  end

end
