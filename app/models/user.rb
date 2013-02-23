class User < ActiveRecord::Base
  has_many :subscriptions

  validates_uniqueness_of :email, :cpf
  validates_presence_of :name, 
    :email, 
    :cpf, 
    :birthday,
    :zipcode,
    :address_street, 
    :address_extra, 
    :address_number,
    :address_district, 
    :city, 
    :state,
    :phone,
    :country

   attr_accessible :name, 
    :email, 
    :cpf, 
    :birthday,
    :zipcode,
    :address_street, 
    :address_extra, 
    :address_number,
    :address_district, 
    :city, 
    :state,
    :phone,
    :country

end
