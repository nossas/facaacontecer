class SubscriptionWorker 
  include Sidekiq::Worker


  # Method to receive the url object from MOIP
  # It also checks which payment_option it should use
  def perform(subscription_id)
    @subscription = Subscription.find_by(id: subscription_id)
    
    if @subscription
      send("perform_#{@subscription.payment_option}")
    end
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


  def perform_creditcard
    true
  end

  def create_payment_instruction(url)
    if @subscription.payments.create(url: url)
      @subscription.wait_confirmation!
    end
  end




end
