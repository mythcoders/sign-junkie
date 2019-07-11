# frozen_string_literal: true

class AlterSeatUc < ActiveRecord::Migration[5.2]
  def change
    remove_index :seats, %i[workshop_id user_id]
    add_index :seats, %i[workshop_id user_id item_description_id], unique: true
  end
end
