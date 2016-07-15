module Rubill
  class GetDisbursementData < Base
    def self.remote_class_name
      "GetDisbursementData"
    end

    def self.find_by_send_pay_id(sent_pay_id)
      Query.get_disbursement_data(sent_pay_id)
    end
  end
end
