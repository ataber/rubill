module Rubill
  class Customer < Base
    def contacts
      CustomerContact.active_by_customer(id)
    end
  end
end
