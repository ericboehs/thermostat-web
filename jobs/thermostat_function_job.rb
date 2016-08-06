class ThermostatFunctionJob < Que::Job
  include Particle

  def run function, argument
    puts "ThermostatFunctionJob running: #{function}, #{argument}"
    particle_func function, argument
  end
end
