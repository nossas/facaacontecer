class PaymentInstruction < ActiveRecord::Base
  belongs_to :subscription
  
  # deprecated:
  #attr_accessible :code, :expires_at, :status


  scope :by_month, ->(month) { 
    where("extract(month from paid_at) = ? 
          AND status IN ('done', 'authorized') ", month) 
  }
end
