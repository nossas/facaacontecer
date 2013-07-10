class PaymentInstruction < ActiveRecord::Base
  belongs_to :subscription
  attr_accessible :code, :expires_at, :status


  scope :by_month, ->(month) { where("extract(month from paid_at) = ? and status IN ('done', 'authorized') ", month) }
end
