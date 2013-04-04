# coding: utf-8
class SubscriptionMailer < ActionMailer::Base
  default from:     "Leonardo do Meu Rio <leonardo@meurio.org.br>",
          bcc:      'financiador@meurio.org.br',
          reply_to: 'financiador@meurio.org.br',
          subject:  "Obrigado por financiar o Meu Rio!",
          date:     Date.current

  default_url_options[:host] = 'apoie.meurio.org.br'

  def successful_create_message(subscription)
    @subscription = subscription
    @subscriber   = @subscription.subscriber
    @code         = @subscription.code
    @invite       = @subscriber.invite.code if @subscriber.invite.present?

    mail(to: @subscriber.email)
  end


  def inviter_friend_subscribed(subscription)
    @subscriber = subscription.subscriber
    @host       = @subscriber.invite.host
    @count      = @host.invitees.count
    @invite     = @host.invite.code

    mail(to: @host.email, subject: 'Um amigo já colaborou através do seu link!')
  end

end
