class RemoveUserIdFromSubscriptions < ActiveRecord::Migration
  def up
    remove_column :subscriptions, :user_id
  end

  def down
    add_column :subscription, :user_id
  end
end
