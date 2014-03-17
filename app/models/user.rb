#coding: utf-8
class User < ActiveRecord::Base
  has_many  :subscriptions, foreign_key: :subscriber_id, dependent: :destroy
  has_many  :invitees,      class_name: :Invite, foreign_key: :parent_user_id
  has_one   :invite,        dependent: :destroy

  delegate :project, to: :subscription, allow_nil: true

  # Validates if a CPF is valid/invalid
  validates :cpf, cpf: true

  # Validates if an Email is valid/invalid
  validates :email, email: true

    
  # Validates if a phone number has at least 12 characters
  validates_length_of :phone, minimum: 14

  # Validates the presence of these fields
  validates_presence_of :first_name, :last_name, :email, :cpf, :birthday, 
    :zipcode, :address_street, :address_extra, :address_number, 
    :address_district, :city, :state, :phone, :country


  # Validates if a given user is older than 14 years
  validates_date :birthday, before: -> { 14.years.ago }

  
  after_create :generate_invite_code
  


  def as_json(options={})
    {
      id:         self.id,
      created_at: self.created_at,
    }.merge(options)
  end

  def as_payer
    payer = MyMoip::Payer.new(
      id:             self.id,
      name:           self.name,
      email:          self.email,
      address_city:     self.city,
      address_state:    self.state,
      address_country:  self.country,
      address_cep:      self.zipcode,
      address_phone:    self.phone,
      address_street:         self.address_street,
      address_street_number:  self.address_number,
      address_street_extra:   self.address_extra,
      address_neighbourhood:  self.address_district
    )

    return payer
  end

  private

  def generate_invite_code
    unless self.invite
      invite = self.build_invite(code: SecureRandom.hex(6))
      invite.save!
    end
  end
end
