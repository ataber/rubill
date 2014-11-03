module Rubill
  class CustomerContact < Base
    def self.find_by_customer(customer_id)
      where([Query::Filter.new("customerId", "=", customer_id)])
    end

    def self.remote_class_name
      "CustomerContact"
    end
  end
end
