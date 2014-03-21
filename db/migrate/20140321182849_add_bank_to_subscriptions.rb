class AddBankToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :bank, :string
  end
end
