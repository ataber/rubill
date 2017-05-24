module Rubill
  class Customer < Base
    # The Bill.com API does not currently support searching by email or
    # account number. Be careful as ::find_by_email will load all active
    # Customers into memory
    def self.find_by_email(email)
      active.find { |customer| customer[:email] == email }
    end

    # The Bill.com API does not currently support searching by email or
    # account number. Be careful as ::find_by_account_number will load all
    # active Customers into memory
    def self.find_by_account_number(account_number)
      active.find { |customer| customer[:accNumber] == account_number.to_s }
    end

    def contacts
      CustomerContact.active_by_customer(id)
    end
  end
end
