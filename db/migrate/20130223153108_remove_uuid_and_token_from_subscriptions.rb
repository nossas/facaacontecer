class RemoveUuidAndTokenFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :uuid
    remove_column :subscriptions, :token
  end

end
