module Rubill
  attr_writer :configuration

  def self.configure(&block)
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_accessor :user_name
    attr_accessor :password
    attr_accessor :dev_key
    attr_accessor :org_id
    attr_writer :debug
    attr_writer :sandbox

    def required_keys
      %w(user_name password dev_key org_id)
    end

    def to_hash
      required_keys.each_with_object({}) do |k, h|
        h[k] = send(k.to_sym)
      end
    end

    def missing_keys
      required_keys.reject do |k|
        to_hash[k]
      end
    end

    def debug
      @debug || false
    end

    def sandbox
      @sandbox || false
    end
  end
end

require "rubill/base"
require "rubill/query"
require "rubill/session"

Dir["#{File.dirname(__FILE__)}/rubill/entities/*.rb"].each { |f| require f }
