class AddBirthdayToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :birthday, :date
  end
end
