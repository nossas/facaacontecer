class User < ActiveRecord::Base
  has_many :subscriptions, foreign_key: :subscriber_id, dependent: :destroy
  has_one :invite
  has_many :invitees, class_name: :Invite, foreign_key: :parent_user_id

  delegate :project, to: :subscription, allow_nil: true

  validates :cpf, cpf: true
  validates_date :birthday, before: -> { 14.years.ago }
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

  after_create :generate_invite_code



  def as_json(options={})
    {
      id:         self.id,
      created_at: self.created_at,
    }.merge(options)
  end


  private
    def generate_invite_code
      invite = self.build_invite(code: SecureRandom.hex(6))
      invite.save!
    end
end
