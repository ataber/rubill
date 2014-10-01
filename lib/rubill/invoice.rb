module Rubill
  class Invoice < Base
    def amount_paid
      amount - amount_due
    end

    def amount
      # to_s then to_d because it returns a float
      remote_record[:amount].to_s.to_d
    end

    def amount_due
      # to_s then to_d because it returns a float
      remote_record[:amountDue].to_s.to_d
    end

    def self.invoice_line_item(amount, description, item_id)
      {
        entity: "InvoiceLineItem",
        quantity: 1,
        itemId: item_id,
        # must to_f amount otherwise decimal will be converted to string in JSON
        price: amount.to_f,
        description: description,
      }
    end

    def self.remote_class_name
      "Invoice"
    end
  end
end
