class AddSeatingToCartItems < ActiveRecord::Migration[5.2]
  def change
    add_column :cart_items, :seating, :string
    remove_column :cart_items, :design_id, :integer
  end
end
