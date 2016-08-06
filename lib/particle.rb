module Particle
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
end
