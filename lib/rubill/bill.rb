module Rubill
  class Bill < Base
    def self.send_payment(opts)
      SentPay.create(opts)
    end

    def self.void_sent_payment(id)
      SentPay.void(id)
    end

    def self.remote_class_name
      "Bill"
    end
  end
end
