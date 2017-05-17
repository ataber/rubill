module Rubill
  class CustomerContact < Base
    def self.find_by_customer(customer_id)
      where([Query::Filter.new("customerId", "=", customer_id)])
    end

    def self.active_by_customer(customer_id)
      where(
        [
          Query::Filter.new("customerId", "=", customer_id),
          Query::Filter.new("isActive", "=", "1"),
        ]
      )
    end
  end
end
