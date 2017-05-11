module Rubill
  class GetDisbursementData < Base
    def self.find_by_send_pay_id(sent_pay_id)
      Query.get_disbursement_data(sent_pay_id)
    end
  end
end
