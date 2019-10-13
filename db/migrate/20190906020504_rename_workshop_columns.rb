class RenameWorkshopColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :workshops, :reservation_allow, :overridden_reservation_allow
    rename_column :workshops, :reservation_allow_multiple, :overridden_reservation_allow_multiple
    rename_column :workshops, :reservation_minimum, :overridden_reservation_minimum
    rename_column :workshops, :reservation_maximum, :overridden_reservation_maximum
    rename_column :workshops, :total_seats, :overridden_total_seats
    rename_column :workshops, :reservation_price, :overridden_reservation_price
    rename_column :workshop_types, :reservation_allow, :default_reservation_allow
    rename_column :workshop_types, :reservation_allow_multiple, :default_reservation_allow_multiple
  end
end
