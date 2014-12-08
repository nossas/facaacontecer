class AddOrganizationIdToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :organization_id, :integer, foreign_key: false
  end
end
