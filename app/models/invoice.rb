class Invoice < ActiveRecord::Base
  belongs_to :subscription

  validates :uid, :subscription_id, :value, :occurrence, :status, presence: true
  validates :uid, uniqueness: true

  # Access the subscription's user directly, using the subscription object
  delegate :user, to: :subscription

  # Updates user data on Mailchimp after save a invoice
  include Mailchimped
  after_save { self.delay.update_user_data }

  STATUS = {
    "1" => "started",
    "2" => "waiting",
    "3" => "finished",
    "4" => "rejected",
    "5" => "overdue"
  }

  def self.successful
    where(status: 'finished')
  end
end
