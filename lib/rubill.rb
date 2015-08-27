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
end

require "rubill/session"
require "rubill/query"
require "rubill/base"
require "rubill/bill"
require "rubill/bill_payment"
require "rubill/invoice"
require "rubill/sent_payment"
require "rubill/sent_bill_payment"
require "rubill/received_payment"
require "rubill/vendor"
require "rubill/customer"
require "rubill/customer_contact"
