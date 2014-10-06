module Rubill
  class Configuration
    attr_accessor :user_name
    attr_accessor :password
    attr_accessor :dev_key
    attr_accessor :org_id

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
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    yield(configuration)
  end

  self.configuration ||= Configuration.new
end

require "rubill/session"
require "rubill/base"
require "rubill/bill"
require "rubill/invoice"
require "rubill/sent_pay"
require "rubill/received_pay"
require "rubill/customer"
