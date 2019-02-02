class CartItemsProjectIdNullable < ActiveRecord::Migration[5.2]
  def change
    change_column_null :cart_items, :project_id, true
  end
end
