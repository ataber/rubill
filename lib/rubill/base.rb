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
      new(session.read(remote_class_name, id))
    end

    def self.create(data)
      new(session.create(remote_class_name, data.merge({entity: remote_class_name})))
    end

    def self.update(data)
      session.update(remote_class_name, data.merge({entity: remote_class_name}))
    end

    def self.delete(id)
      session.delete(remote_class_name, id)
    end

    def self.all
      session.list(remote_class_name)
    end

    def self.session
      Session.instance
    end

    private

    def self.remote_class_name
      raise NotImplementedError
    end
  end
end
