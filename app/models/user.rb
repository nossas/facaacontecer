class User < ActiveRecord::Base
  has_many :subscriptions, foreign_key: :subscriber_id
  belongs_to :project

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



  def as_json(options={})
    {
      id:         self.id,
      created_at: self.created_at,
    }.merge(options)
  end

end
