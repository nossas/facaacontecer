class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :uid, null: false
      t.integer :subscription_id, null: false
      t.decimal :value, null: false
      t.integer :occurrence, null: false
      t.string :status, null: false

      t.timestamps
    end

    add_index :invoices, :uid, unique: true
  end
end
