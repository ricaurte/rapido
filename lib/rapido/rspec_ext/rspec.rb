module Rspec

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

ENV['RAPIDO'] == true ? Rspec.enable_rapido : Rspec.disable_rapido
