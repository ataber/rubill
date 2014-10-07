require "spec_helper"

module Rubill
  describe Base do
    describe ".initialize" do
      let(:remote) { {id: "123"} }

      it "sets the remote record" do
        expect(described_class.new(remote).remote_record).to eq(remote)
      end
    end

    describe "#[]" do
      let(:remote) { {id: "123"} }
      subject { described_class.new(remote) }

      it "delegates to the remote record" do
        expect(subject[:id]).to eq("123")
      end
    end

    describe "#[]=" do
      let(:remote) { {id: "123"} }
      subject { described_class.new(remote) }

      it "delegates to the remote record" do
        subject[:id] = "321"
        expect(subject[:id]).to eq("321")
      end
    end
  end
end