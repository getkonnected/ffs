require 'ffs/configuration'
require 'ffs/version'
require 'ffs/share'
require 'generators/ffs/install_generator'

module FFS
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
