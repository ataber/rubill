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
      where([Query::Filter.new("isActive", "=", "1")])
    end

    def id
      remote_record[:id]
    end

    def save
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

    def self.where(filters=[], hash_filters={})
      filters, hash_filters = [], filters if filters.is_a?(Hash)
      raise ArgumentError unless filters.all? { |f| f.is_a?(Query::Filter) }

      hash_filters.each do |field, value|
        filters << Query::Filter.new(field.to_s, "=", value)
      end

      result = []
      start = 0
      step = 999
      loop do
        chunk = Query.list(remote_class_name, start, step, filters)

        if !chunk.empty?
          records = chunk.map { |r| new(r) }
          result += records
          start += step
        end

        break if chunk.length < step
      end

      result
    end

    def self.all
      # Note: this method returns ALL of desired entity, including inactive
      where([])
    end

    private

    def self.remote_class_name
      raise NotImplementedError
    end
  end
end
