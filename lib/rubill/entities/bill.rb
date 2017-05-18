module Rubill
  class Bill < Base
    def self.send_payment(opts)
      SentPayment.create(opts)
    end
  end
end
