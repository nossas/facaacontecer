class AddAnonymousAndGiftToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :anonymous, :boolean
    add_column :subscriptions, :gift, :boolean
  end
end
