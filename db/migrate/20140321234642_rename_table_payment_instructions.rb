class RenameTablePaymentInstructions < ActiveRecord::Migration
  def change
    rename_table :payment_instructions, :payments
  end
end
