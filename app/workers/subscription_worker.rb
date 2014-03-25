class SubscriptionWorker 
  include Sidekiq::Worker
  sidekiq_options retry: 2


  # Warn the tech team when a sidekiq job fails twice

  sidekiq_retries_exhausted do |msg|
    #TODO: send email to tech@meurio.org.br
    Sidekiq.logger.warn "ATTENTION: Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end




  # Method to receive the url object from MOIP
  # It also checks which payment_option it should use
  def perform(subscription_id)
    @subscription = Subscription.find_by(id: subscription_id)
      
    send("perform_#{@subscription.payment_option}")
  end

  # BOLETO
  def perform_slip
    @subscription.boleto
    create_payment_instruction(@subscription.boleto.url)
  end

  # DEBITO
  def perform_debit
    @subscription.debito
    create_payment_instruction(@subscription.debito.url)
  end

  # CREDITCARD
  def perform_creditcard
    create_payment_instruction(nil)
  end

  def create_payment_instruction(url)
    if @subscription.payments.create(url: url)
      @subscription.wait_confirmation!
    end
  end




end
