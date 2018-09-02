class AddPaymentMethodToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :payment_method, :string, length: 10
  end
end
