class Project < ActiveRecord::Base

  # Kinda useful when dealing with inherited resources
  attr_accessible :description, :expiration_date, :goal, :image, :title, :video

  # Orders here will be used when the user made the checkout action (sent its data to moip)
  has_many :orders

  # Supporters are the people who supported the campaign with a valid payment token
  has_many :supporters, through: :orders, source: :user, conditions: 'orders.token IS NOT NULL'

  # Attributes that should be present when creating or updating a project
  validates :title, :description, :goal, :expiration_date, presence: true



  # The time the project expires
  def end_date
    (self.expiration_date - Time.now.day).day
  end

  # The revenue of the project so far
  def revenue
    self.orders.raised.sum(:value)
  end

  # The percent of the project that it's done
  def percent
    (self.revenue.to_f / self.goal.to_f) * 100
  end

  # The project raised 100%?
  def funded?
    self.percent >= 100
  end

end
