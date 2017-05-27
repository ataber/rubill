module Rubill
  class Query
    attr_accessor :url
    attr_accessor :options

    def initialize(url, opts={})
      self.url = url
      self.options = opts
    end

    def self.list(entity, start=0, step=999, filters=[])
      execute(
          "/List/#{entity}.json",
          start: start,
          max: step,
          filters: filters.map(&:to_hash),
       )
    end

    def self.read(entity, id)
      execute("/Crud/Read/#{entity}.json", id: id)
    end

    def self.create(entity, object={})
      execute("/Crud/Create/#{entity}.json", obj: object)
    end

    def self.update(entity, object={})
      execute("/Crud/Update/#{entity}.json", obj: object)
    end

    def self.delete(entity, id)
      execute("/Crud/Delete/#{entity}.json", id: id)
    end

    def self.pay_bills(opts={})
      execute("/PayBills.json", opts)
    end

    def self.receive_payment(opts={})
      execute("/RecordARPayment.json", opts)
    end

    def self.send_payment(opts={})
      execute("/RecordAPPayment.json", opts)
    end

    def self.void_sent_payment(id)
      execute("/VoidAPPayment.json", sentPayId: id)
    end

    def self.void_received_payment(id)
      execute("/VoidARPayment.json", id: id)
    end

    def self.send_vendor_invite(vendorId, email)
      execute("/SendVendorInvite.json", vendorId: vendorId, email: email)
    end

    def self.get_disbursement_data(id)
      execute("/GetDisbursementData.json", sentPayId: id)
    end

    def self.get_check_image_data(id)
      execute("/GetCheckImageData.json", sentPayId: id)
    end

    def execute
      Session.instance.execute(self)
    end

    def self.execute(url, options)
      new(url, options).execute
    end

    class Filter
      attr_accessor :field
      attr_accessor :op
      attr_accessor :value

      def initialize(field, op, value)
        self.field, self.op, self.value = field, op, value
      end

      def to_hash
        {
          field: field,
          op: op,
          value: value,
        }
      end
    end
  end
end
