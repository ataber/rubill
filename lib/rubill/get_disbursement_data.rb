module Rubill
  class GetDisbursementData < Base
    def self.find_by_sent_pay(sent_pay_id)
      where([Query::Filter.new("sentPayId", "=", sent_pay_id)])
    end

    def self.remote_class_name
      "GetDisbursementData"
    end
  end
end
