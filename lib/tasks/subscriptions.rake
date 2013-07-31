require 'httparty'
require 'base64'

namespace :subscriptions do
  desc "Update every subscription/payment instruction for credit card subscribers"
  task :fetch_creditcard_status => :environment do

   @codes = ['', 'authorized', 'started', 'done', 'done', 'canceled', 'waiting', 'reversed', 'refunded']    
   @auth = { username: ENV['MOIP_PROD_TOKEN'] , password: ENV['MOIP_PROD_KEY'] }

   puts @auth.inspect


   Subscription.where(payment_option: :creditcard).find_each(batch_size: 100) do |s|
    response = fetch_subscription_status("subscriptions/#{s.code}/invoices", { basic_auth: @auth })
    if response['invoices'].length > 0
      invoices = response['invoices']

      invoices.each do |i|
        instruction = PaymentInstruction.find_or_create_by_code(i['id'].to_s)
        instruction.subscription = s
        instruction.url          = ENV['MOIP_API_URL'] + "invoices/#{i['id']}" 
        instruction.sequence     = "0"
        instruction.status = @codes[i['status']['code'].to_i]
        date = i['creation_date']
        if i['status']['code'].to_i == 3 or i['status']['code'].to_i == 4
          instruction.paid_at = "#{date['day']}/#{date['month']}/#{date['year']} #{date['hour']}:#{date['minute']}:#{date['second']}".to_time
        end

        instruction.save!

        puts "Saved instruction #{instruction.code} with status #{i['status']['code']}/#{i['status']['description']} for subscription #{s.code}"
      end


    end
   end
  end

  desc "TODO"
  task :fetch_bankslip_status => :environment do
    nil
  end



  def fetch_subscription_status(url, options = {})
    link  = ENV['MOIP_API_URL'] + url
    

    puts "Getting from #{link}"
    HTTParty.get(link, options )
  end
end
