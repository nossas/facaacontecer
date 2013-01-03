class AddCpfAndAddressNeighbourhoodAndAddressNumberToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :cpf, :string
    add_column :orders, :address_neighbourhood, :string
    add_column :orders, :address_number, :integer
  end
end
