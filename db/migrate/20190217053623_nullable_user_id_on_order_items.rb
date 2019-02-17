class NullableUserIdOnOrderItems < ActiveRecord::Migration[5.2]
  def change
    change_column_null :order_items, :user_id, true
  end
end
