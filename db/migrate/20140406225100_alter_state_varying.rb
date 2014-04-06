class AlterStateVarying < ActiveRecord::Migration
  def change
    change_column :users, :state, :string, limit: 255
  end
end
