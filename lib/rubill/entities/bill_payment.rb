module Rubill
  class BillPayment < Base
    def self.pay_bills(opts)
      SentBillPayment.create(opts)
    end
  end
end
