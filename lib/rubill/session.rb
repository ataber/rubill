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
      data = data.dup
      data.delete(:content)
      {
        sessionId: id,
        devKey: self.class.configuration.dev_key,
        data: data.to_json,
      }
    end

    def file_from_data(data = {})
      if data && data.is_a?(Hash) && data.key?(:fileName)
        file = Tempfile.new(data[:fileName])
        file.write data[:content]
        file.rewind
      end

      file
    end

    def _post(url, data, retries=0)
      begin
        file = file_from_data(data)
        response_data = self.class._post(self.base_uri + url, options(data), file)
        file.close if file
        response_data
      rescue APIError => e
        if e.message =~ /Session is invalid/ && retries < 3
          login
          _post(url, data, retries + 1)
        else
          raise
        end
      end
    end

    def self._post(url, options, file = nil)
      post_options = options

      if file
        post_options[:file] = file
        post_options[:multipart] = true
      end

      if self.configuration.debug
        post_options[:debug_output] = $stdout
      end

      response = RestClient.post(url, post_options)
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
