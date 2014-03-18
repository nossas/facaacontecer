# This module handles all business/payment logic that 
# belongs to subscribers.
module Subscriber
  extend ActiveSupport::Concern


  included do

    # Build subscriber data into a JSON hash
    def as_payer
      {
        id:                     id, 
        name:                   "#{first_name} #{last_name}",
        email:                  email,
        address_street:         address_street,
        address_street_number:  address_number,
        address_street_extra:   address_extra,
        address_neighbourhood:  address_district,
        address_city:           city,
        address_state:          state,
        address_country:        'BRA',
        address_cep:            only_numerical(zipcode),
        address_phone:          only_numerical(phone)
    
      }
    end

    
    # Set new instance for MyMoip 
    def build_payer
      MyMoip::Payer.new(as_payer)
    end


    # Remove non numerical values for given inputs
    def only_numerical(value)
      return value.to_s.gsub(/[\D]/, '')
    end

  end
end
