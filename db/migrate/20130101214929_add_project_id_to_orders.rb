class AddProjectIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :project_id, :integer
    add_index :orders, :project_id
  end
end
