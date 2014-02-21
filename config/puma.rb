# Sample configuration for PUMA
#
threads 8,32
workers 3

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

preload_app!
