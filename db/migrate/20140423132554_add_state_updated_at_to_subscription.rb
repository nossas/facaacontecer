class AddStateUpdatedAtToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :state_updated_at, :datetime
  end
end
