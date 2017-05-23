[![Build Status](https://travis-ci.org/ataber/rubill.svg?branch=master)](https://travis-ci.org/ataber/rubill)
[![Code Climate](https://codeclimate.com/github/ataber/rubill/badges/gpa.svg)](https://codeclimate.com/github/ataber/rubill)

# rubill

Ruby interface to Bill.com's API

Bill.com's developer documentation: https://developer.bill.com/hc/en-us/categories/201195646

## Setup:

```ruby
Rubill.configure do |config|
  # REQUIRED CONFIGURATION
  config.user_name = "USERNAME@EMAIL.COM"
  config.password = "XXXX"
  config.dev_key = "XXXX"
  config.org_id = "XXXX"
  
  # OPTIONAL CONFIGURATION
  # Point base_uri to app-stage.bill.com instead of app.bill.com, default `false`
  # config.sandbox = true
  #
  # Print debugging information to $stdout, default `false`
  # config.debug = true
end
```

## Usage:

Rubill exposes the following entities directly:

* ActgClass
* Attachment
* Bill
* BillPayment
* ChartOfAccount
* Customer
* CustomerContact
* GetCheckImageData
* GetDisbursementData
* Invoice
* Item
* Location
* ReceivedPayment
* SentBillPayment
* SentPayment
* Vendor

For each you can sync a hash-like record with Bill.com by calling for example

```ruby
Rubill::Customer.create(attrs)
```

The resulting return value will be a `Rubill::Customer` object, which you can update by modifying via hash assignment and then calling `save`. Note that this flow does not work for ReceivedPayments or SentPayments, as you will need to void and then recreate these records.
