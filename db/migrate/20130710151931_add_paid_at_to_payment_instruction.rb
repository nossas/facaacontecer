class AddPaidAtToPaymentInstruction < ActiveRecord::Migration
  def change
    add_column :payment_instructions, :paid_at, :datetime
  end
end
