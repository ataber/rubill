require "httparty"
require "json"
require "singleton"

module Rubill
  class Session
    include HTTParty
    include Singleton

    class APIError < StandardError; end

    base_uri "https://api.bill.com/api/v2"

    attr_accessor :id

    def initialize
      config = self.class.configuration
      if missing = (!config.missing_keys.empty? && config.missing_keys)
        raise "Missing key(s) in configuration: #{missing}"
      end

      login
    end

    def execute(query)
      _post(query.url, query.options)
    end

    def login
      self.id = self.class.login
    end

    def self.login
      login_options = {
        headers: default_headers,
        query: {
          password: configuration.password,
          userName: configuration.user_name,
          devKey: configuration.dev_key,
          orgId: configuration.org_id,
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
          devKey: self.class.configuration.dev_key,
          data: data.to_json,
        },
      }
    end

    def self.default_headers
      {"Content-Type" => "application/x-www-form-urlencoded"}
    end

    def _post(url, options, retries=0)
      begin
        self.class._post(url, options)
      rescue APIError => e
        if e.message =~ /Session is invalid/ && retries < 3
          login
          _post(url, options, retries + 1)
        else
          raise
        end
      end
    end

    def self._post(url, options)
      result = JSON.parse(post(url, options).body, symbolize_names: true)

      unless result[:response_status] == 0
        raise APIError.new(result[:response_data][:error_message])
      end

      result[:response_data]
    end

    def self.configuration
      Rubill::configuration
    end
  end
end
