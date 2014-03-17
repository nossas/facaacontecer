class RenameSubscriptionStatusToState < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :status, :state
  end
end
