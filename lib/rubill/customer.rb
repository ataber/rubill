module Rubill
  class Customer < Base
    def self.find_by_name(name)
      where([Query::Filter.new("name", "=", name)]).first
    end

    def contacts
      CustomerContact.active_by_customer(id)
    end

    def self.remote_class_name
      "Customer"
    end
  end
end
