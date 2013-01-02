class AddValueToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :value, :decimal
  end
end
