require './lib/dotenv'
require 'bundler/setup'
require 'awesome_print'
require 'pg'
require 'active_record'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/cookies'
require 'slim'
require 'httparty'

# ActiveRecord::Base.establish_connection ENV['POOLED_DATABASE_URL'] || ENV['DATABASE_URL']

def particle_func function, argument
  HTTParty.post("https://api.particle.io/v1/devices/#{ENV.fetch('PARTICLE_DEVICE_ID')}/#{function}", body: {
    arg: argument, access_token: ENV.fetch('PARTICLE_ACCESS_TOKEN')
  }).tap { |response| raise response.code.to_s unless response.code == 200 }['result']
end

def particle_var variable
  HTTParty.get(
    "https://api.particle.io/v1/devices/#{ENV.fetch('PARTICLE_DEVICE_ID')}/#{variable}?access_token=#{ENV.fetch('PARTICLE_ACCESS_TOKEN')}"
  ).tap { |response| raise response.code.to_s unless response.code == 200 }['result']
end


get '/' do
  @notice = cookies.delete 'notice'
  @thermostat = JSON.parse particle_var 'info'
  slim :thermostat
end


post '/' do
  response = particle_func "targetTemp", params[:target_temp]
  cookies['notice'] = "Temperature set to #{params[:target_temp]}F"
  redirect to('/')
end

get 'apple-touch.png' do
  send_file File.join(settings.public_folder, 'apple-touch.png')
end
