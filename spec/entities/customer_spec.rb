require 'spec_helper'

module Rubill
  describe Customer do
    it { expect(described_class).to be < Rubill::Base }

    describe "::find_by_email" do
      let(:active_customer) do
        customer = double(described_class)

        allow(customer).to receive(:[]).with(:email).and_return("c_email")

        customer
      end

      before(:each) do
        allow(described_class).to receive(:active).and_return([
          active_customer
        ])
      end

      it "finds a customer by email" do
        expect(described_class.find_by_email("c_email")).to eq(active_customer)
      end

      it "nil if customer does not exist or is inactive" do
        expect(described_class.find_by_email("unknown_email")).to be_nil
      end
    end
  end
end
