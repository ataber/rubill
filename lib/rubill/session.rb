require "httparty"
require "json"
require "singleton"

module Rubill
  class Session
    include HTTParty
    include Singleton

    base_uri "https://api.bill.com/api/v2"

    CREDENTIALS = Rubill.configuration.to_hash

    attr_accessor :id

    def initialize
      config = Rubill.configuration
      if missing = (!config.missing_keys.empty? && config.missing_keys)
        raise "Missing key(s) in configuration: #{missing}"
      end

      login
    end

    def read(entity, id)
      _post("/Crud/Read/#{entity}.json", options(id: id))
    end

    def create(entity, object={})
      _post("/Crud/Create/#{entity}.json", options(obj: object))
    end

    def update(entity, object={})
      _post("/Crud/Update/#{entity}.json", options(obj: object))
    end

    def delete(entity, id)
      _post("/Crud/Delete/#{entity}.json", options(id: id))
    end

    def receive_payment(opts={})
      _post("/RecordARPayment.json", options(opts))
    end

    def send_payment(opts={})
      _post("/RecordAPPayment.json", options(opts))
    end

    def void_sent_payment(id)
      _post("/VoidAPPayment.json", options(sentPayId: id))
    end

    def void_received_payment(id)
      _post("/VoidARPayment.json", options(id: id))
    end

    def list(entity)
      # Note: this method returns ALL of desired entity, including inactive
      result = []
      start = 0
      step = 999
      loop do
        chunk = _post("/List/#{entity}.json", options(start: start, max: step))

        if !chunk.empty?
          result += chunk
          start += step
        else
          break
        end
      end

      result
    end

    def login
      self.id = self.class.login
    end

    def self.login
      login_options = {
        headers: default_headers,
        query: {
          password: CREDENTIALS["password"],
          userName: CREDENTIALS["user_name"],
          devKey: CREDENTIALS["dev_key"],
          orgId: CREDENTIALS["org_id"],
        }
      }
      login = _post("/Login.json", login_options)
      login[:sessionId]
    end

    def options(data={})
      {
        headers: self.class.default_headers,
        query: {
          sessionId: id,
          devKey: CREDENTIALS["dev_key"],
          data: data.to_json,
        },
      }
    end

    def self.default_headers
      {"Content-Type" => "application/x-www-form-urlencoded"}
    end

    def _post(url, options)
      self.class._post(url, options)
    end

    def self._post(url, options)
      result = JSON.parse(post(url, options).body, symbolize_names: true)

      raise result[:response_data][:error_message] unless result[:response_status] == 0
      result[:response_data]
    end
  end
end
