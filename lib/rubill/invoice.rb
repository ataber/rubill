module Rubill
  class Invoice < Base
    def amount_paid
      amount - amount_due
    end

    def amount
      remote_record[:amount]
    end

    def amount_due
      remote_record[:amountDue]
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
