require "spec_helper"

module Rubill
  describe Attachment do
    it { expect(described_class).to be < Rubill::Base }

    let(:options) { { "a" => "b" } }

    describe ".send_attachment" do
      let(:id) { "123" }
      let(:file_name) { "file.txt" }

      context "with plain text" do
        before do
          expect(Query).to receive(:upload_attachment).with({
            id: id,
            fileName: file_name,
            document: 'Test text',
            content: 'Test text'
          })
        end

        it "should be uploaded" do
          described_class.send_attachment(id, file_name, 'Test text')
        end
      end
    end
  end
end
