#coding: utf-8
class User < ActiveRecord::Base
  establish_connection Rails.env.production? ? ENV["ACCOUNTS_DATABASE"] : "accounts_#{Rails.env}"

  has_many  :subscriptions, foreign_key: :subscriber_id, dependent: :destroy
  has_many  :invitees,      class_name: :Invite, foreign_key: :parent_user_id
  has_one   :invite,        dependent: :destroy

  delegate :project, to: :subscription, allow_nil: true

  validates_date :birthday, before: -> { 14.years.ago }
  validates :cpf, cpf: true
  validates_uniqueness_of :email
  validates_presence_of :first_name, :last_name, :email, :cpf, :birthday, :postal_code, :address_street, :address_extra, :address_number, :address_district, :city, :state, :phone, :country

  after_create :generate_invite_code

  def name
    "#{self.first_name} #{self.last_name}"
  end

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
      address_cep:      self.postal_code,
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
