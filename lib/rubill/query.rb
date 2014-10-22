module Rubill
  class Query
    attr_accessor :url
    attr_accessor :options

    def initialize(url, opts={})
      self.url = url
      self.options = opts
    end

    def self.list(entity, start=0, step=999, filters=[])
      new(
          "/List/#{entity}.json",
          options(
            start: start,
            max: step,
            filters: filters.map(&:to_hash),
          ),
       ).execute
    end

    def self.read(entity, id)
      new("/Crud/Read/#{entity}.json", options(id: id)).execute
    end

    def self.create(entity, object={})
      new("/Crud/Create/#{entity}.json", options(obj: object)).execute
    end

    def self.update(entity, object={})
      new("/Crud/Update/#{entity}.json", options(obj: object)).execute
    end

    def self.delete(entity, id)
      new("/Crud/Delete/#{entity}.json", options(id: id)).execute
    end

    def self.receive_payment(opts={})
      new("/RecordARPayment.json", options(opts)).execute
    end

    def self.send_payment(opts={})
      new("/RecordAPPayment.json", options(opts)).execute
    end

    def self.void_sent_payment(id)
      new("/VoidAPPayment.json", options(sentPayId: id)).execute
    end

    def self.void_received_payment(id)
      new("/VoidARPayment.json", options(id: id)).execute
    end

    def execute
      Session.instance.execute(self)
    end

    def self.options(*args)
      Session.instance.options(*args)
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