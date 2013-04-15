class AddPaymentOptionToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :payment_option, :string, null: false, default: :creditcard
  end
end
