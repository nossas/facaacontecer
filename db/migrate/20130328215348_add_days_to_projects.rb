class AddDaysToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :days, :integer
  end
end
