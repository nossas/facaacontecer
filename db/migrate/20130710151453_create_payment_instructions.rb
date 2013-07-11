class CreatePaymentInstructions < ActiveRecord::Migration
  def change 
    create_table :payment_instructions do |t|
      t.string      :code
      t.references  :subscription
      t.string      :status
      t.datetime    :expires_at

      t.timestamps
    end
    add_index :payment_instructions, :subscription_id
  end

end
