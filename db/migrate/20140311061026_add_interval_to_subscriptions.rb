class AddIntervalToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :interval, :integer, null: false
  end
end
