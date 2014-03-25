class RenamePaymentStatusToState < ActiveRecord::Migration
  def change
    rename_column :payments, :status, :state
  end
end
