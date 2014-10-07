require "spec_helper"

module Rubill
  describe Session do
    describe "#initialize" do
      context "without a configuration" do
        it "should raise an error about missing keys" do
          expect(-> { described_class.instance }).to raise_error(/Missing key/)
        end
      end

      context "with a configuration" do
        before do
          described_class.configure do |c|
            c.user_name = "test"
            c.password  = "pass"
            c.dev_key   = "dev_key"
            c.org_id    = "org_id"
          end

          expect(described_class).to receive(:login) { "abc123" }
        end

        it "logs in" do
          expect(described_class.instance.id).to eq("abc123")
        end
      end
    end

    describe ".configure" do
      it "should set the necessary fields" do
        described_class.configure do |c|
          c.user_name = "test"
          c.password  = "pass"
          c.dev_key   = "dev_key"
          c.org_id    = "org_id"
        end

        expect(described_class.configuration.missing_keys).to be_empty
      end
    end

    describe "._post" do
      context "when the API returns a nonzero status" do
        before do
          expect(described_class).to receive(:post) do
            double(
              body: {
                status: "1",
                response_data: {
                  error_message: "houston"
                }
              }.to_json
            )
          end
        end

        it "throws an API error with the error message" do
          expect(-> { described_class._post("test", {}) }).to(
            raise_error(described_class::APIError, /houston/)
          )
        end
      end
    end
  end
end
