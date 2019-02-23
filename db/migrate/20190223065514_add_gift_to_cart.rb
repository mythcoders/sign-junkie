class AddGiftToCart < ActiveRecord::Migration[5.2]
  def change
    add_column :cart_items, :gift, :boolean, default: false, null: false
  end
end
