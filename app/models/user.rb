#coding: utf-8
class User < ActiveRecord::Base

  # located @ app/observers/user_observer.rb
  include UserObserver

  has_one   :invite,        dependent: :destroy
  has_many  :invitees,      class_name: :Invite, foreign_key: :parent_user_id
  has_many  :subscriptions, dependent: :destroy, inverse_of: :user
  has_many  :payments,      through: :subscriptions


  # Validates if a CPF is valid/invalid
  validates :cpf, cpf: true

  # Validates if an Email is valid/invalid
  validates :email, email: true

  # Validates if a phone is valid
  validates :phone, phone: true
    

  # Validates the presence of these fields
  validates_presence_of :first_name, :last_name, :email, :cpf, :birthday, 
    :postal_code, :address_street, :address_extra, :address_number, 
    :address_district, :city, :state, :phone, :country


  # Validates if a given user is older than 14 years
  validates_date :birthday, before: -> { 14.years.ago }

  # Accepts nested attributes for subscriptions
  accepts_nested_attributes_for :subscriptions


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
end
