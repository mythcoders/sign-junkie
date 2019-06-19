class UserIdConstraintOnSeats < ActiveRecord::Migration[5.2]
  def change
    add_index :seats, [:workshop_id, :user_id], unique: true
  end
end
