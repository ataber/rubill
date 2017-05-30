require 'spec_helper'

module Rubill
  describe Invoice do
    it { expect(described_class).to be < Rubill::Base }

    describe "#send_email" do
      let(:email_headers) { { subject: "email subject" } }
      let(:email_content) { "email body" }

      it "sends email for an invoice" do
        expect(Query).to receive(:execute).with("/SendInvoice.json", {
          invoiceId: "test_invoice_id",
          headers: email_headers,
          content: { body: "email body" }
        })

        described_class.new(id: "test_invoice_id").
          send_email(email_headers, email_content)
      end
    end
  end
end
