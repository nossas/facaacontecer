class RevertSubscriptionsIntervalToString < ActiveRecord::Migration
  def change
    change_column :subscriptions, :interval, :string
  end
end
