class OrderItemDescription < ActiveRecord::Migration[5.2]
  def change
    rename_column :order_items, :description, :addon
    change_column_null :order_items, :addon, true
    add_column :order_items, :project, :string
  end
end
