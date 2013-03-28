class Project < ActiveRecord::Base

  # Kinda useful when dealing with inherited resources
  attr_accessible :description, :expiration_date, :goal, :image, :title, :video

  # Orders here will be used when the user made the checkout action (sent its data to moip)
  has_many :subscriptions

  # Supporters are the people who supported the campaign with a valid payment token
  has_many :subscribers, through: :subscriptions, conditions: "status = 'active'", uniq: true

  # Attributes that should be present when creating or updating a project
  validates :title, :description, :goal, :expiration_date, presence: true



  # The time the project expires
  def end_date
    (self.expiration_date - Date.current).to_i
  end

  # The revenue of the project so far
  def revenue
    self.subscriptions.raised.sum(:value)
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
