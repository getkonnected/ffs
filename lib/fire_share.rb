require 'fire_share/share'
require 'fire_share/configuration'
require 'fire_share/version'

module FireShare
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
