require "spec_helper"

module Rubill
  describe Attachment do
    it { expect(described_class).to be < Rubill::Base }

    let(:options) { { "a" => "b" } }

    describe ".send_attachment" do
      let(:id) { "123" }
      let(:file_name) { "file.txt" }
      let(:content) { "Test text" }
      let(:file) { double(Tempfile, rewind: true, close: true, unlink: true) }

      context "with plain text" do
        it "should be uploaded" do
          allow(Tempfile).to receive(:new).and_return(file)
          expect(file).to receive(:write).with(content)

          expect(Query).to receive(:execute).with("/UploadAttachment.json", {
            id: id,
            fileName: file_name,
            document: 'Test text',
            '_top_level_data' => {
              file: file,
              multipart: true
            }
          })

          described_class.send_attachment(id, file_name, content)
        end
      end
    end
  end
end
