require 'base64'

module Rubill
  class Attachment < Base
    def self.send_attachment(object_id, file_name, content)
      file = Tempfile.new(file_name)

      begin
        file.write(content)
        file.rewind

        Query.execute("/UploadAttachment.json", {
          id: object_id,
          fileName: file_name,
          document: content,
          "_top_level_data" => {
            file: file,
            multipart: true
          }
        })
      ensure
        # Ensure temp file is garbage collected with explicit close
        # https://ruby-doc.org/stdlib-1.9.3/libdoc/tempfile/rdoc/Tempfile.html
        file.close
        file.unlink
      end
    end
  end
end
