class MailWorker
  include SuckerPunch::Worker


  def perform(subscription)
    SubscriptionMailer.successful_create_message(subscription).deliver
  end
end
