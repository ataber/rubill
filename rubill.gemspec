Gem::Specification.new do |spec|
  spec.name        = 'rubill'
  spec.version     = '0.2.1'
  spec.date        = Date.today.to_s
  spec.summary     = "Interface with Bill.com"
  spec.description = "A Ruby interface to Bill.com's API"
  spec.authors     = ["Andrew Taber", "Aleksey Chebotarev"]
  spec.email       = ['andrew.e.taber@gmail.com', 'aleksey.chebotarev@gmail.com']
  spec.homepage    = 'http://rubygems.org/gems/rubill'
  spec.license     = 'MIT'

  spec.files          = Dir['lib/*.rb']
  spec.require_paths  = ["lib"]

  spec.add_runtime_dependency "rest-client", '~> 0'
  spec.add_runtime_dependency "json", '~> 0'

  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rake", "~> 10.3"
end
