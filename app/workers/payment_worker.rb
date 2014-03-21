class PaymentWorker
  include Sidekiq::Worker




  def perform(name, count)
    puts "test"
  end






end
