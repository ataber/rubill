module Rubill
  class BillPayment < Base
    def self.pay_bills(opts)
      SentBillPayment.create(opts)
    end

    def self.remote_class_name
      "BillPayment"
    end
  end
end
