class AddSequenceToPaymentInstructions < ActiveRecord::Migration
  def change
    add_column :payment_instructions, :sequence, :string
  end
end
