class ChangeDefaultValueForSubscriptionsPaymentOption < ActiveRecord::Migration
  def change
    change_column :subscriptions, :payment_option, :string, default: '', null: false
  end
end
