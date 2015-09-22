module Rubill
  class SentBillPayment < Base
    def self.create(opts)
      Query.pay_bills(opts)
    end

    def self.active
      where([Query::Filter.new("status", "!=", "4")])
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
      Query.void_sent_payment(id)
    end

    def self.remote_class_name
      "SentBillPay"
    end
  end
end
