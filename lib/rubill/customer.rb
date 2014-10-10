module Rubill
  class Customer < Base
    def self.find_by_name(name)
      record = active.detect do |d|
        d[:name] == name
      end

      raise NotFound unless record
      new(record)
    end

    def contacts
      CustomerContact.find_by_customer(self)
    end

    def create_credit(amount, description="", syncReference="")
      data = {
        customerId: id,
        amount: amount.to_f,
        description: description,
        syncReference: syncReference,
        paymentType: "5",
        paymentDate: Date.today,
      }

      ReceivedPayment.create(data)
    end

    def self.remote_class_name
      "Customer"
    end
  end
end
