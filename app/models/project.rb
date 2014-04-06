class Project < ActiveRecord::Base

  # Orders here will be used when the user made the checkout action (sent its data to moip)
  has_many :subscriptions, dependent: :destroy

  # Supporters are the people who supported the campaign with a valid payment token
  has_many :users, -> { where(subscriptions: { state: :active }).uniq }, through: :subscriptions


  # Attributes that should be present when creating or updating a project
  validates :title, :description, presence: true
end
