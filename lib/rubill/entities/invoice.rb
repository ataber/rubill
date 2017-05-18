module Rubill
  class Invoice < Base
    def amount_paid
      amount - amount_due
    end

    def amount
      remote_record[:amount]
    end

    def send_email(subject, body, contact_emails)
      Query.execute(
        "/SendInvoice.json",
        {
          invoiceId: id,
          headers: {
            subject: subject,
            toEmailAddresses: contact_emails
          },
          content: {
            body: body
          }
        }
      )
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
