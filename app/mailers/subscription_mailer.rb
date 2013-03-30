class SubscriptionMailer < ActionMailer::Base
  default from:     "Leonardo do Meu Rio <leonardo@meurio.org.br>",
          bcc:      'financiador@meurio.org.br',
          reply_to: 'financiador@meurio.org.br',
          subject:  "Obrigado por financiar o Meu Rio!",
          date:     Date.current

  default_url_options[:host] = 'apoie.meurio.org.br'

  def successful_create_message(subscription)
    @subscriber = subscription.subscriber
    @code       = subscription.code
    @invite     = @subscriber.invite.code if @subscriber.invite
    mail(to: @subscriber.email)
  end

end
