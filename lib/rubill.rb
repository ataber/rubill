module Rubill
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :user_name
    attr_accessor :password
    attr_accessor :dev_key
    attr_accessor :org_id

    def to_hash
      {
        "user_name" => user_name,
        "password"  => password,
        "dev_key"   => dev_key,
        "org_id"    => org_id,
      }
    end
  end
end
