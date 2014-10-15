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
      CustomerContact.find_by_customer(id)
    end

    def self.remote_class_name
      "Customer"
    end
  end
end
