module Rubill
  class ReceivedPayment < Base
    def self.create(opts)
      Query.receive_payment(opts)
    end

    def self.active
      where([Query::Filter.new("status", "!=", "1")])
    end

    def void
      delete
    end

    def delete
      self.class.delete(id)
    end

    def self.delete(id)
      # To overwrite delete method in superclass
      void(id)
    end

    def self.void(id)
      Query.void_received_payment(id)
    end

    def self.remote_class_name
      "ReceivedPay"
    end
  end
end
