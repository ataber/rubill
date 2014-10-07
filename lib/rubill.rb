module Rubill
  def self.configure(&block)
    Rubill::Session.configure(&block)
  end
end

require "rubill/session"
require "rubill/base"
require "rubill/bill"
require "rubill/invoice"
require "rubill/sent_payment"
require "rubill/received_payment"
require "rubill/customer"
