Gem::Specification.new do |s|
  s.name        = 'rubill'
  s.version     = '0.0.1'
  s.date        = '2014-09-31'
  s.summary     = "Interface with Bill.com"
  s.description = "A Ruby interface to Bill.com's API"
  s.authors     = ["Andrew Taber"]
  s.email       = 'andrew.e.taber@gmail.com '
  s.files       = [
                    "lib/rubill.rb",
                    "lib/rubill/session.rb",
                    "lib/rubill/query.rb",
                    "lib/rubill/base.rb",
                    "lib/rubill/bill.rb",
                    "lib/rubill/invoice.rb",
                    "lib/rubill/sent_payment.rb",
                    "lib/rubill/received_payment.rb",
                    "lib/rubill/customer.rb",
                    "lib/rubill/customer_contact.rb",
                  ]
  s.homepage    = 'http://rubygems.org/gems/rubill'
  s.license     = 'MIT'

  s.add_dependency "httparty"
  s.add_dependency "json"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
