# If you have a very small app you may be able to
# increase this, but in general 3 workers seems to
# work best
worker_processes 3

# Load your app into the master before forking
# workers for super-fast worker spawn times
preload_app true

# Immediately restart any workers that
# haven't responded within 30 seconds
timeout 30


# Our background workers. We don't need to pay
# for a single worker on Heroku ;)
#after_fork do |server, worker|
#  SuckerPunch.config do
#    queue name: :subscription_queue,  worker: SubscriptionWorker, size: 5
#    queue name: :mailing_queue,       worker: MailWorker, size: 5
#  end
#end
