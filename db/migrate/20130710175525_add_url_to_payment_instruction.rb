class AddUrlToPaymentInstruction < ActiveRecord::Migration
  def change
    add_column :payment_instructions, :url, :string
  end
end
