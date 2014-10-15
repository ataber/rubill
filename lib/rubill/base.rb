module Rubill
  class Base
    attr_accessor :remote_record

    class NotFound < StandardError; end

    def initialize(remote)
      self.remote_record = remote
    end

    def [](key)
      remote_record.send(:[], key)
    end

    def []=(key, value)
      remote_record.send(:[]=, key, value)
    end

    def self.active
      # There is also a way to list only active via the API but it's opaque
      # and unlikely to be much faster than doing it in Ruby

      # This should be overwritten in subclasses that don't have this field (i.e. payments)
      all.select do |record|
        record[:isActive] == "1"
      end
    end

    def id
      remote_record[:id]
    end

    def update
      self.class.update(remote_record)
    end

    def delete
      self.class.delete(id)
    end

    def self.find(id)
      new(Query.read(remote_class_name, id))
    end

    def self.create(data)
      new(Query.create(remote_class_name, data.merge({entity: remote_class_name})))
    end

    def self.update(data)
      Query.update(remote_class_name, data.merge({entity: remote_class_name}))
    end

    def self.delete(id)
      Query.delete(remote_class_name, id)
    end

    def self.all
      # Note: this method returns ALL of desired entity, including inactive
      result = []
      start = 0
      step = 999
      loop do
        chunk = Query.list(remote_class_name, start, step)

        if !chunk.empty?
          records = chunk.map { |r| new(r) }
          result += records
          start += step
        else
          break
        end
      end

      result
    end

    private

    def self.remote_class_name
      raise NotImplementedError
    end
  end
end
