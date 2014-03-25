class Payment < ActiveRecord::Base
  belongs_to :subscription

  delegate :user, to: :subscription, allow_nil: true

  
  validates_presence_of :subscription



  scope :by_month, ->(month) { 
    where("extract(month from paid_at) = ? 
          AND status IN ('done', 'authorized') ", month) 
  }
end
