class AddEmailAndProjectIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :email, :string
    remove_column :orders, :tracking_number
    remove_column :orders, :shipping
    remove_column :orders, :price
    remove_column :orders, :user_id

    add_index :orders, :email
  end
end
