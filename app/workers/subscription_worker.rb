class SubscriptionWorker
  include HTTParty
  include SuckerPunch::Worker
 
  base_uri MOIP_URL 


  def perform(code)
  end

end
