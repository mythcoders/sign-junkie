class AlterSeatUc < ActiveRecord::Migration[5.2]
  def change
    remove_index :seats, [:workshop_id, :user_id]
    add_index :seats, [:workshop_id, :user_id, :item_description_id], unique: true
  end
end
