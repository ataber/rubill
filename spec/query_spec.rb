require "spec_helper"

module Rubill
  describe Query do
    describe ".execute" do
      let(:url) { "url" }
      let(:options) { {"a" => "b"} }

      it "instantiates a new query and executes it" do
        instance = double(execute: true)
        expect(described_class).to receive(:new).with(url, options) { instance }
        expect(instance).to receive(:execute)
        described_class.execute(url, options)
      end
    end

    describe "#execute" do
      subject { described_class.new("url", {}) }

      it "delegates to the Session instance" do
        instance = double(execute: true)
        allow(Session).to receive(:instance) { instance }
        expect(instance).to receive(:execute).with(subject)
        subject.execute
      end
    end
  end
end