#coding: utf-8
class User < ActiveRecord::Base

  has_one   :invite,        dependent: :destroy
  has_many  :invitees,      class_name: :Invite, foreign_key: :parent_user_id
  has_many  :subscriptions, dependent: :destroy, inverse_of: :user
  has_many  :payments,      through: :subscriptions


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

  # After creation, associante an invite code to this current user/instance 
  after_create :generate_invite_code
 
  # Accepts nested attributes for subscriptions
  accepts_nested_attributes_for :subscriptions





  # Method to create or update an user based on 
  # received params
  
  def self.initialize_or_update_by(options = {})
    return User.new unless options.has_key?(:email)

    user = User.find_by(email: options[:email])
   
    return User.new(options) if user.nil?

    user.update_attributes(options)
    user
  end



  # Isolating business logic inside a method
  # So if you need to call app/business/subscriber
  # Do as the following:
  # 
  #   user.business.as_payer
  #   user.business.build_payer
  
  def business
    # located @ app/business/subscriber.rb
    extend Business::Payer
  end





  # Generate a invite code after the creation 
  # of an user. This code allow tracking of
  # who is inviting who in the system
  private
    def generate_invite_code
      invite = self.build_invite(code: SecureRandom.hex(6))
      invite.save!
    end
end
