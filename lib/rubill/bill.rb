module Rubill
  class Bill < Base
    def self.send_payment(opts)
      session.send_payment(opts)
    end

    def self.void_sent_payment(id)
      session.void_sent_payment(id)
    end

    def self.remote_class_name
      "Bill"
    end
  end
end
