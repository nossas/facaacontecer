class RenameSubscriptionSubscriberToUser < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :subscriber_id, :user_id
  end
end
