class AdjustCart < ActiveRecord::Migration[5.2]
  def change
    change_column_null :cart_items, :workshop_id, false
    change_column_null :cart_items, :user_id, false
    change_column_null :cart_items, :session_id, false
    add_reference :cart_items, :project, null: false, foreign_key: true
    add_reference :cart_items, :addon, foreign_key: true
  end
end
