require "httparty"
require "json"
require "singleton"

module Rubill
  class APIError < StandardError; end

  class Session
    include HTTParty
    include Singleton

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
        password: configuration.password,
        userName: configuration.user_name,
        devKey: configuration.dev_key,
        orgId: configuration.org_id,
      }
      login = _post("/Login.json", login_options)
      login[:sessionId]
    end

    def options(data={})
      {
        sessionId: id,
        devKey: self.class.configuration.dev_key,
        data: data.to_json,
      }
    end

    def self.default_headers
      {"Content-Type" => "application/x-www-form-urlencoded"}
    end

    def _post(url, data, retries=0)
      begin
        self.class._post(url, options(data))
      rescue APIError => e
        if e.message =~ /Session is invalid/ && retries < 3
          login
          _post(url, data, retries + 1)
        else
          raise
        end
      end
    end

    def self._post(url, options)
      target_environment = if self.configuration.sandbox
        "https://api-stage.bill.com/api/v2"
      else
        "https://api.bill.com/api/v2"
      end

      self.base_uri target_environment

      response = post(
        url,
        body: options,
        headers: default_headers,
        debug_output: self.configuration.debug ? $stdout : nil
      )

      result = JSON.parse(response.body, symbolize_names: true)

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
