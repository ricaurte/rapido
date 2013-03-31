module RSpec

  def self.rapido_enabled?
    @rapido_enabled
  end

  def self.enable_rapido
    @rapido_enabled = true
  end

  def self.disable_rapido
    @rapido_enabled = false
  end

end

ENV['RAPIDO'] == true ? RSpec.enable_rapido : RSpec.disable_rapido
