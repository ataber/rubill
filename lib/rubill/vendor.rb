module Rubill
  class Vendor < Base
    def self.remote_class_name
      "Vendor"
    end

    def bills
      Bill.where([
        Query::Filter.new("isActive", "=", "1"),
        Query::Filter.new("vendorId", "=", id),
      ])
    end

    def send_invite(email)
      Query.send_vendor_invite(id, email)
    end
  end
end
