class AddPaymentPlanToItemDescriptions < ActiveRecord::Migration[5.2]
  def change
    remove_column :reservations, :payment_plan
    remove_column :item_descriptions, :seats_booked
    add_column :item_descriptions, :payment_plan, :string
  end
end
