Gem::Specification.new do |s|
  s.name        = 'rubill'
  s.version     = '0.1.7'
  s.date        = '2014-09-31'
  s.summary     = "Interface with Bill.com"
  s.description = "A Ruby interface to Bill.com's API"
  s.authors     = ["Andrew Taber"]
  s.email       = 'andrew.e.taber@gmail.com'
  s.files       = [
                    "lib/rubill.rb",
                    "lib/rubill/session.rb",
                    "lib/rubill/query.rb",
                    "lib/rubill/base.rb",
                    "lib/rubill/entities/bill.rb",
                    "lib/rubill/entities/bill_payment.rb",
                    "lib/rubill/entities/invoice.rb",
                    "lib/rubill/entities/sent_payment.rb",
                    "lib/rubill/entities/sent_bill_payment.rb",
                    "lib/rubill/entities/received_payment.rb",
                    "lib/rubill/entities/vendor.rb",
                    "lib/rubill/entities/customer.rb",
                    "lib/rubill/entities/customer_contact.rb",
                    "lib/rubill/entities/attachment.rb",
                    "lib/rubill/entities/location.rb",
                    "lib/rubill/entities/actg_class.rb",
                  ]
  s.homepage    = 'http://rubygems.org/gems/rubill'
  s.license     = 'MIT'

  s.add_dependency "rest-client"
  s.add_dependency "json"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
end
