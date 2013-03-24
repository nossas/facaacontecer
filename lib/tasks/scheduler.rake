desc "This task is called by the Heroku scheduler add-on"
task :update_subscriptions => :environment do
  puts "Updating subscriptions..."

  
  puts "done."
end

task :send_reminders => :environment do
end
