module Rubill
  class CustomerContact < Base
    def self.find_by_customer(customer_id)
      records = active.select do |c|
        c[:customerId] == customer_id
      end

      records.map do |record|
        new(record)
      end
    end

    def self.remote_class_name
      "CustomerContact"
    end
  end
end
