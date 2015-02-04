[![Build Status](https://travis-ci.org/ataber/rubill.svg?branch=master)](https://travis-ci.org/ataber/rubill)
[![Code Climate](https://codeclimate.com/github/ataber/rubill/badges/gpa.svg)](https://codeclimate.com/github/ataber/rubill)

rubill
======

Ruby interface to Bill.com's API

Bill.com's own documentation: http://developer.bill.com/api-documentation/overview/

======

Setup:

```
Rubill.configure do |config|
  config.user_name = "USERNAME@EMAIL.COM"
  config.password = "XXXX"
  config.dev_key = "XXXX"
  config.org_id = "XXXX"
end
```

======

Usage:

Rubill exposes the following entities directly: Customer, Customer Contact, Bill, ReceivedPayment, SentPayment, Vendor, and Invoice.

For each you can sync a hash-like record with Bill.com by calling for example

```
Rubill::Customer.create(attrs)
```

The resulting return value will be a Rubill::Customer object, which you can update by modifying via hash assignment and then calling `save`. Note that this flow does not work for ReceivedPayments or SentPayments, as you will need to void and then recreate these records.
