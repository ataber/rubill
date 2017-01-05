require 'base64'

module Rubill
  class Attachment < Base
    def self.send_attachment(object_id, file_name, content)
      Query.upload_attachment({
        id: object_id,
        fileName: file_name,
        document: content
      })
    end

    def self.remote_class_name
      "Attachment"
    end
  end
end
