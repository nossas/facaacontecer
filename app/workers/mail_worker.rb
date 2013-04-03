class MailWorker
  include SuckerPunch::Worker


  def perform(subscription)
    @subscription = subscription
    SuckerPunch::Queue.new(:mail).async.perform(send_subscription_success_notification)
    SuckerPunch::Queue.new(:mail).async.perform(send_inviter_notification)
  end

  def send_subscription_success_notification
    SubscriptionMailer.successful_create_message(@subscription).deliver
  end

  def send_inviter_notification
    if @subscription.subscriber.invite and @subscription.subscriber.invite.host.present?
      SubscriptionMailer.inviter_friend_subscribed(@subscription).deliver 
    end
  end
end
