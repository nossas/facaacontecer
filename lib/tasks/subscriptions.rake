require 'httparty'

namespace :subscriptions do
  desc "Update every subscription/payment instruction for credit card subscribers"
  task :fetch_creditcard_status => :environment do
   @auth = { username: ENV['MOIP_TOKEN'] , password: ENV['MOIP_AUTHORIZATION'] }



   Subscription.where(payment_option: :creditcard).find_each(batch_size: 100) do |s|
    response = fetch_subscription_status("subscriptions/#{s.code}/invoices")
    puts response.body.inspect
   end
  end

  desc "TODO"
  task :fetch_bankslip_status => :environment do
    nil
  end



  def fetch_subscription_status(url, options = {})
    options.merge!({ basic_auth: @auth })
    HTTParty.get(ENV['MOIP_API_URL'] + url, options)
  end
end
