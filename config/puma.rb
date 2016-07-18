threads 5, 5
port ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RACK_ENV") { "development" }
workers 3
preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection ENV['DATABASE_URL']
end
