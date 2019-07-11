# frozen_string_literal: true

class UserIdConstraintOnSeats < ActiveRecord::Migration[5.2]
  def change
    add_index :seats, %i[workshop_id user_id], unique: true
  end
end
