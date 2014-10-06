module Rubill
  class SentPay < Base
    def self.create(opts)
      session.send_payment(opts)
    end

    def self.delete(id)
      void(id)
    end

    def self.void(id)
      session.void_sent_payment(id)
    end

    def self.remote_class_name
      "SentPay"
    end
  end
end
