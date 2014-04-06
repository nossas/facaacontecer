class RenameUsersZipcodeToPostalCode < ActiveRecord::Migration
  def change
    rename_column :users, :zipcode, :postal_code
  end
end
