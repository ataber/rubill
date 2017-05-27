require "rest-client"
require "json"
require "singleton"
require "tempfile"


module Rubill
  class APIError < StandardError; end

  class Session
    include Singleton

    attr_accessor :id, :base_uri

    def initialize
      config = self.class.configuration
      if missing = (!config.missing_keys.empty? && config.missing_keys)
        raise "Missing key(s) in configuration: #{missing}"
      end

      if config.sandbox
        self.base_uri = "https://api-stage.bill.com/api/v2"
      else
        self.base_uri = "https://api.bill.com/api/v2"
      end

      login
    end

    def execute(query)
      _post(query.url, query.options)
    end

    def login
      self.id = self.class.login(self.base_uri)
    end

    def self.login(base_uri)
      login_options = {
        password: configuration.password,
        userName: configuration.user_name,
        devKey: configuration.dev_key,
        orgId: configuration.org_id,
      }
      login = _post(base_uri + "/Login.json", login_options)
      login[:sessionId]
    end

    def options(data={})
      top_level_data = data.delete("_top_level_data")

      {
        sessionId: id,
        devKey: self.class.configuration.dev_key,
        data: data.to_json,
      }.merge(top_level_data.to_h)
    end

    def _post(url, data, retries=0)
      begin
        self.class._post(self.base_uri + url, options(data))
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
      if self.configuration.debug
        options[:debug_output] = $stdout
      end

      response = RestClient.post(url, options)
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
