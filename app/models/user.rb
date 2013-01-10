class User < ActiveRecord::Base
  has_many :orders

  validates_uniqueness_of :email
  validates_presence_of :name, 
    :email, 
    :cpf, 
    :birthday,
    :address_street, 
    :address_street_extra, 
    :address_number,
    :address_neighbourhood, 
    :address_city, 
    :address_state,
    :address_country, 
    :addres_cep, 
    :address_phone



end
