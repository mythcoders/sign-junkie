class AddRefundDate < ActiveRecord::Migration[5.2]
  def change
    add_column :item_descriptions, :refund_date, :datetime
  end
end
