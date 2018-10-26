class OrderItemToEvent < ActiveRecord::Migration[5.2]
  def change
    change_table :order_items do |t|
      t.references :event, index: true, foreign_key: true
    end
  end
end
