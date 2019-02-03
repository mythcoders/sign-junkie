class OrderItemsReferencesUser < ActiveRecord::Migration[5.2]
  def change
    change_table :order_items do |t|
      t.remove :attendee
      t.remove :email
      t.references :user
    end
  end
end
