class Payment < ActiveRecord::Base
  belongs_to :subscription
  
  scope :by_month, ->(month) { 
    where("extract(month from paid_at) = ? 
          AND status IN ('done', 'authorized') ", month) 
  }
end
