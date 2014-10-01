Gem::Specification.new do |s|
  s.name        = 'rubill'
  s.version     = '0.0.1'
  s.date        = '2014-09-31'
  s.summary     = "Interface with Bill.com"
  s.description = "A Ruby interface to Bill.com's API"
  s.authors     = ["Andrew Taber"]
  s.email       = 'andrew.e.taber@gmail.com '
  s.files       = ["lib/rubill.rb"]
  s.homepage    = 'http://rubygems.org/gems/rubill'
  s.license     = 'MIT'

  s.add_dependency "httparty"

  s.add_development_dependency "rspec"
end
