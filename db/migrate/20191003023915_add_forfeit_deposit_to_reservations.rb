class AddForfeitDepositToReservations < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :forfeit_deposit, :boolean, default: false
  end
end
