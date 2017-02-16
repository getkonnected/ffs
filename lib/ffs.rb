require 'ffs/share'
require 'ffs/configuration'
require 'ffs/version'

module FFS
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
