module Rubill
  class ReceivedPayment < Base
    def self.create(opts)
      session.receive_payment(opts)
    end

    def self.active
      all.select do |pay|
        # Payment is not void
        pay[:status] != "1"
      end
    end

    def delete
      self.class.delete(id)
    end

    def self.delete(id)
      void(id)
    end

    def self.void(id)
      session.void_received_payment(id)
    end

    def self.remote_class_name
      "ReceivedPay"
    end
  end
end
