module RSpec

  def self.rapido_enabled?
    @rapido_enabled
  end

  def self.enable_rapido
    puts "Rapido - enabled"
    @rapido_enabled = true
  end

  def self.disable_rapido
    puts "Rapido - disabled (to enable rapido send RAPIDO=true as an environment parameter with your rspec tests)"
    @rapido_enabled = false
  end

end

ENV['RAPIDO'] == "true" ? RSpec.enable_rapido : RSpec.disable_rapido
