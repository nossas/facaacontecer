class MailWorker
  include SuckerPunch::Worker


  def perform(sub)
    SubscriptionMailer.successful_create_message(sub).deliver
  end
end
