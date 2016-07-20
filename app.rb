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
  HTTParty.post("https://api.particle.io/v1/devices/#{ENV.fetch('PARTICLE_DEVICE_ID')}/#{function}", timeout: 5, body: {
    arg: argument, access_token: ENV.fetch('PARTICLE_ACCESS_TOKEN')
  }).tap { |response| raise response.code.to_s unless response.code == 200 }['result']
end

def particle_var variable
  HTTParty.get(
    "https://api.particle.io/v1/devices/#{ENV.fetch('PARTICLE_DEVICE_ID')}/#{variable}?access_token=#{ENV.fetch('PARTICLE_ACCESS_TOKEN')}", timeout: 5
  ).tap { |response| raise response.code.to_s unless response.code == 200 }['result']
end


get '/' do
  @notice = cookies.delete 'notice'
  @thermostat = JSON.parse particle_var 'info'
  slim :thermostat
end


get '/set_mode/:mode' do
  response = particle_func "setMode", params[:mode]
  cookies['notice'] = "Mode set to #{params[:mode].capitalize}"
  redirect to('/')
end

post '/smartthings/:mode' do
  st_base_url = "https://graph.api.smartthings.com/api/smartapps/installations/#{ENV.fetch 'SMARTTHINGS_APPLICATION_ID'}/switches/#{ENV.fetch 'SMARTTHINGS_SWITCH_ID'}"
  headers = { "Authorization" => "Bearer #{ENV.fetch('SMARTTHINGS_ACCESS_TOKEN')}" }

  if params[:mode] == "cool_on"
    HTTParty.post(
      "#{st_base_url}/on", timeout: 5, headers: headers
    ).tap { |response| raise response.code.to_s unless response.code == 201 }
  end

  if params[:mode] == "cool_off"
    HTTParty.post(
      "#{st_base_url}/off", timeout: 5, headers: headers
    ).tap { |response| raise response.code.to_s unless response.code == 201 }
  end

  status 200
end

post '/' do
  response = particle_func "targetTemp", params[:target_temp]
  cookies['notice'] = "Temperature set to #{params[:target_temp]}F"
  redirect to('/')
end

get 'apple-touch.png' do
  send_file File.join(settings.public_folder, 'apple-touch.png')
end
