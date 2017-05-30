module Rubill
  class Invoice < Base
    def amount_paid
      amount - amount_due
    end

    def amount
      remote_record[:amount]
    end

    ##
    # Send email about invoice to customer
    #
    # Bill.com Documentation:
    # https://developer.bill.com/hc/en-us/articles/208197236
    #
    # Possible header keys:
    #   * fromUserId
    #   * toEmailAddresses
    #   * ccMe
    #   * subject
    #
    # Possible content keys:
    #   * body
    #
    # Will use settings/content from the Default Email Template if
    # nothing specified
    def send_email(headers = {}, content = {})
      options = { headers: headers, content: content }

      Query.execute("/SendInvoice.json", { invoiceId: id }.merge(options))
    end

    def amount_due
      remote_record[:amountDue]
    end

    def self.line_item(amount, description, item_id)
      {
        entity: "InvoiceLineItem",
        quantity: 1,
        itemId: item_id,
        # must to_f amount otherwise decimal will be converted to string in JSON
        price: amount.to_f,
        description: description,
      }
    end
  end
end
