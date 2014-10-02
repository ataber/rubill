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

Rubill exposes three entities directly: Customer, Bill, and Invoice.

For each you can sync a hash-like record with Bill.com by calling for example

```
Rubill::Customer.create(attrs)
```

The resulting return value will be a Customer object, which you can update by modifying via hash assignment and then calling `update`
