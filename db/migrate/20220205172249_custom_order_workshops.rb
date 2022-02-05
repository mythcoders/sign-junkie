class CustomOrderWorkshops < ActiveRecord::Migration[7.0]
  def change
    add_column :workshop_types, :multiple_seats, :boolean, default: false
    add_column :workshop_types, :in_person, :boolean, default: true
  end
end
