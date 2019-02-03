class OrderItemDescriptionLength < ActiveRecord::Migration[5.2]
  def change
    change_column :order_items, :description, :string, null: false
  end
end
