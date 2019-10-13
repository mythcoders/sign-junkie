class CancelReservationsOption < ActiveRecord::Migration[5.2]
  def change
    add_column :workshop_types, :default_reservation_cancel_minimum_not_met, :boolean
    add_column :workshops, :overridden_reservation_cancel_minimum_not_met, :boolean, default: :null
  end
end
