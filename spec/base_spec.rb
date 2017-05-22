require "spec_helper"

module Rubill
  describe Base do
    describe ".initialize" do
      let(:remote) { {id: "123"} }

      it "sets the remote record" do
        expect(described_class.new(remote).remote_record).to eq(remote)
      end
    end

    describe ".where" do
      context "when given a list of Query::Filter objects" do
        before { allow(described_class).to receive(:remote_class_name) { "test" } }
        let(:filter) { Query::Filter.new("id", ">", "3") }

        it "creates a list query with the filters" do
          expect(Query).to receive(:list).with(
            described_class.remote_class_name,
            0,
            999,
            [filter],
          ) { [] }
          described_class.where([filter])
        end

        it "creates simple equality filters when passed a hash" do
          filters = nil
          expect(Query).to receive(:list) { |_, _, _, fs| filters = fs }
          described_class.where(id: 3, status: "5")

          expect(filters.count).to eq(2)

          id_filter = filters.first
          expect(id_filter.field).to eq("id")
          expect(id_filter.op).to eq("=")
          expect(id_filter.value).to eq(3)
        end
      end

      context "when given a list of things that aren't filters" do
        it "raises an argument error" do
          expect(-> { described_class.where([{"a" => "A"}, "b", 3]) }).to(
            raise_error(ArgumentError))
        end
      end
    end

    describe ".find_by_name" do
      let(:filter_double) { double(Query::Filter) }

      before(:each) do
        allow(Query::Filter).to receive(:new).with("name", "=", anything).
          and_return(filter_double)
      end

      it "finds an entity by name" do
        result_double = double(Hash)

        allow(Query).to receive(:list).with("Base", 0, 1, [ filter_double ]).
          and_return([ result_double ])

        expect(described_class).to receive(:new).with(result_double)

        described_class.find_by_name("Name")
      end

      it "returns nil if entity not found" do
        allow(Query).to receive(:list).with("Base", 0, 1, [ filter_double ]).
          and_return([])

        expect(described_class.find_by_name("Name")).to be_nil
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
