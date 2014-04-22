class Invoice < ActiveRecord::Base
  belongs_to :subscription

  validates :uid, :subscription_id, :value, :occurrence, :status, presence: true
  validates :uid, uniqueness: true

  STATUS = {
    "1" => "started",
    "2" => "waiting",
    "3" => "finished",
    "4" => "rejected",
    "5" => "overdue"
  }
end
