module Rubill
  class GetCheckImageData < Base
    def self.remote_class_name
      "GetCheckImageData"
    end

    def find_by_send_pay_id(sent_pay_id)
      Query.get_check_image_data(sent_pay_id)
    end
  end
end
