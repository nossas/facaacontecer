class Project < ActiveRecord::Base

  # DEPRECATED:
  # attr_accessible

  # Orders here will be used when the user made the checkout action (sent its data to moip)
  has_many :subscriptions, dependent: :destroy

  # Supporters are the people who supported the campaign with a valid payment token
  has_many :users, -> { 
    where(subscriptions: { state: :active }).uniq }, through: :subscriptions

  # Fetches only anonymous subscribers
  has_many :anonymous_users, -> { 
    where(subscriptions: { status: :active, anonymous: true }).uniq },
    through: :subscriptions

  # Attributes that should be present when creating or updating a project
  validates :title, :description, :goal, :expiration_date, presence: true


  # Saves the days to the expiration date
  before_save :set_total_days


  # The time the project expires
  def end_date 
    ((self.expiration_date - Date.current)).to_i
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

  def expired?
    self.end_date <= 0
  end

  private
    def set_total_days
      if self.expiration_date_changed?
        self.days = (self.expiration_date - Date.current).to_i
      end
    end
end
