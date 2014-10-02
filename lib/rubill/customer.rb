module Rubill
  class Customer < Base
    def self.find_by_name(name)
      record = active.detect do |d|
        d[:name] == name
      end

      raise NotFound unless record
      new(record)
    end

    def self.receive_payment(opts)
      session.receive_payment(opts)
    end

    def self.void_received_payment(id)
      session.void_received_payment(id)
    end

    def create_credit(amount, description="")
      data = {
        customerId: remote_record.id,
        amount: amount.to_f,
        description: description,
        paymentType: "5",
        paymentDate: Date.today,
      }

      self.class.receive_payment(data)
    end

    def self.remote_class_name
      "Customer"
    end
  end
end
