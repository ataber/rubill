require "spec_helper"

module Rubill
  describe Session do
    subject { described_class.instance }

    describe "#initialize" do
      context "without a configuration" do
        it "should raise an error about missing keys" do
          expect(-> { subject }).to raise_error(/Missing key/)
        end
      end

      context "with a configuration" do
        before do
          Rubill.configure do |c|
            c.user_name = "test"
            c.password  = "pass"
            c.dev_key   = "dev_key"
            c.org_id    = "org_id"
          end

          expect(described_class).to \
            receive(:login).with('https://api.bill.com/api/v2') { "abc123" }
        end

        it "logs in" do
          expect(subject.id).to eq("abc123")
        end
      end

      context "with a sandbox configuration" do
        subject { described_class.clone.instance }

        before do
          Rubill.configure do |c|
            c.user_name = "test"
            c.password  = "pass"
            c.dev_key   = "dev_key"
            c.org_id    = "org_id"
            c.sandbox   = true
          end

          expect(described_class).to \
            receive(:login).with('https://api-stage.bill.com/api/v2') { "abc123" }
        end

        it "logs in" do
          expect(subject.id).to eq("abc123")
        end
      end
    end

    describe ".configure" do
      it "should set the necessary fields" do
        Rubill.configure do |c|
          c.user_name = "test"
          c.password  = "pass"
          c.dev_key   = "dev_key"
          c.org_id    = "org_id"
        end

        expect(described_class.configuration.missing_keys).to be_empty
      end
    end

    describe "#_post" do
      let(:url) { "/url" }
      let(:data) { {entity: "Bill", amount: 1.0} }
      let(:body) do
        {
          sessionId: "abc123",
          devKey: "dev_key",
          data: data.to_json,
        }
      end

      context "with non-empty options" do
        before do
          Rubill.configure do |c|
            c.user_name = "test"
            c.password  = "pass"
            c.dev_key   = "dev_key"
            c.org_id    = "org_id"
          end

          allow(described_class).to receive(:login) { "abc123" }
        end

        it "wraps the data with the proper session information" do
          expect(described_class).to receive(:_post).
            with("https://api.bill.com/api/v2" + url, body)

          subject._post(url, data)
        end
      end

      context "when the class throws an error" do
        it "reraises the error" do
          expect(described_class).to receive(:_post) do
            raise APIError.new("failed")
          end

          expect(-> { subject._post("url", {}) }).to raise_error(/failed/)
        end

        context "which is an invalid session error" do
          it "logs in and tries again" do
            counter = 0
            expect(described_class).to receive(:_post).twice do
              counter += 1
              if counter <= 1
                raise APIError.new("Session is invalid. Please log in.")
              else
                true
              end
            end

            expect(subject).to receive(:login)
            subject._post(url, data)
          end
        end
      end
    end

    describe "#execute" do
      let(:query) { Query.new("url", {"a" => "b"}) }

      it "takes a Query object and posts using its data" do
        expect(subject).to receive(:_post).with("url", {"a" => "b"})
        subject.execute(query)
      end
    end

    describe "._post" do
      context "with data" do
        let(:url) { "http://example.com/url" }
        let(:data) { {entity: "Bill", amount: 1.0} }
        let(:body) do
          {
            sessionId: "abc123",
            devKey: "dev_key",
            data: data.to_json,
          }
        end

        let(:response_json) do
          {
            response_status: 0,
            response_data: { name: "abc" },
          }.to_json
        end

        it "puts the data in the post body and parses with symbol keys" do
          expect(RestClient).to receive(:post).with(
            url,
            body
          ) { double(body: response_json) }

          expect(described_class._post(url, body)).to eq({name: "abc"})
        end

        context "with debug option" do
          subject { described_class.clone.instance }
          let(:response_json) do
            {
              response_status: 0,
              response_data: { name: "abc", debug_output: '' },
            }.to_json
          end

          before do
            Rubill.configure do |c|
              c.user_name = "test"
              c.password  = "pass"
              c.dev_key   = "dev_key"
              c.org_id    = "org_id"
              c.debug     = true
            end
          end

          it "response with debug output" do
            expect(RestClient).to receive(:post) { double(body: response_json) }

            expect(described_class._post(url, body)).to include(:debug_output)
          end
        end
      end

      context "when the API returns a nonzero status" do
        before do
          expect(RestClient).to receive(:post) do
            double(
              body: {
                response_status: 1,
                response_data: {
                  error_message: "houston"
                }
              }.to_json
            )
          end
        end

        it "throws an API error with the error message" do
          expect(-> { described_class._post("test", {}) }).to(
            raise_error(APIError, /houston/)
          )
        end
      end
    end
  end
end
