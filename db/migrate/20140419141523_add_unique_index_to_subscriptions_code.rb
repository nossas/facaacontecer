class AddUniqueIndexToSubscriptionsCode < ActiveRecord::Migration
  def up
    remove_index :subscriptions, :code
    add_index :subscriptions, :code, unique: true
  end

  def down
    remove_index :subscriptions, :code
    add_index :subscriptions, :code
  end
end
