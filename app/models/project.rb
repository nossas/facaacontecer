class Project < ActiveRecord::Base

  # Kind of useful when dealing with inherited resources
  attr_accessible :description, :expiration_date, :goal, :image, :title, :video

  # Orders here will be used when the user made the checkout action (sent its data to moip)
  has_many :orders

  # Attributes that should be present when creating or updating a project
  validates :title, :description, :goal, :expiration_date, presence: true


end
