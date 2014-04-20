class ChangeColumnStateFromSubscriptions < ActiveRecord::Migration
  def up
    change_column :subscriptions, :state, :string, default: "processing"
  end

  def down
    change_column :subscriptions, :state, :string, default: nil
  end
end
