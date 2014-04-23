class AddCreatedOnMoipAtToInvoice < ActiveRecord::Migration
  def change
    add_column :invoices, :created_on_moip_at, :datetime
  end
end
