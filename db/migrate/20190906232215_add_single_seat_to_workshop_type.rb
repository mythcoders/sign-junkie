class AddSingleSeatToWorkshopType < ActiveRecord::Migration[5.2]
  def change
    add_column :workshop_types, :default_single_seat_allow, :boolean
    add_column :workshops, :overridden_single_seat_allow, :boolean, default: :null
  end
end
