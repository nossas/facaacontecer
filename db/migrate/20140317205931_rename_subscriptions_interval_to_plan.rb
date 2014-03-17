class RenameSubscriptionsIntervalToPlan < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :interval, :plan
  end
end
