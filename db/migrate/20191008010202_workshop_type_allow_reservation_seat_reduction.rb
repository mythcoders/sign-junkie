class WorkshopTypeAllowReservationSeatReduction < ActiveRecord::Migration[5.2]
  def change
    add_column :workshop_types, :default_reservation_allow_guest_cancel_seat, :boolean, default: true
    add_column :workshops, :overridden_reservation_allow_guest_cancel_seat, :boolean
  end
end
