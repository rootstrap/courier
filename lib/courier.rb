require 'rack'
require 'courier/version'
require 'courier/configuration'
require 'courier/user_signature_service'
require 'courier/request'
require 'courier/middleware'

module Courier
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end
end
