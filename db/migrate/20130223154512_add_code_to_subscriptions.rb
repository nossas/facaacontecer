class AddCodeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :code, :string
    add_index :subscriptions, :code
  end
end
