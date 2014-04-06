class AddIntervalToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :interval, :integer, default: 0, null: false
  end
end
