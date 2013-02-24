class AddSubscriberIdToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :subscriber_id, :integer
    add_index :subscriptions, :subscriber_id
  end
end
