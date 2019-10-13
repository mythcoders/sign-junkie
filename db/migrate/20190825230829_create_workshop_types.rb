class CreateWorkshopTypes < ActiveRecord::Migration[5.2]
  def up
    execute(IO.read(Rails.root.join('db', 'scripts', '20190825230829_data_backup.sql')))

    create_table :workshop_types do |t|
      t.string :name
      t.boolean :active
      t.boolean :reservation_allow
      t.boolean :reservation_allow_multiple
      t.integer :default_total_seats
      t.decimal :default_reservation_price
      t.integer :default_reservation_minimum
      t.integer :default_reservation_maximum
      t.timestamps
    end

    unless WorkshopType.any?
      WorkshopType.create!(name: 'Public',
                           active: true,
                           reservation_allow: true,
                           reservation_allow_multiple: true,
                           default_total_seats: 18,
                           default_reservation_price: BigDecimal('50.00'),
                           default_reservation_minimum: 4,
                           default_reservation_maximum: 11)
      WorkshopType.create!(name: 'Private',
                           active: true,
                           reservation_allow: true,
                           reservation_allow_multiple: false,
                           default_total_seats: 18,
                           default_reservation_price: BigDecimal('100.00'),
                           default_reservation_minimum: 12,
                           default_reservation_maximum: 18)
    end

    remove_column :workshops, :allow_custom_stencils
    rename_column :workshops, :total_tickets, :total_seats
    add_column :workshops, :workshop_type_id, :integer
    add_column :workshops, :reservation_allow, :boolean
    add_column :workshops, :reservation_allow_multiple, :boolean
    add_column :workshops, :reservation_minimum, :integer
    add_column :workshops, :reservation_maximum, :integer

    Workshop.where(is_public: true).update_all(workshop_type_id: WorkshopType.where(name: 'Public').first.id)
    Workshop.where(is_public: false).update_all(workshop_type_id: WorkshopType.where(name: 'Private').first.id)

    add_foreign_key :workshops, :workshop_types, index: true
    change_column_null :workshops, :workshop_type_id, false, WorkshopType.first.id
    remove_column :workshops, :is_public
  end

  def down
    add_column :workshops, :is_public, :boolean, default: true, null: false

    execute(IO.read(Rails.root.join('db', 'scripts', '20190825230829_data_restore.sql')))

    add_column :workshops, :allow_custom_stencils, :boolean
    rename_column :workshops, :total_seats, :total_tickets
    remove_column :workshops, :workshop_type_id
    remove_column :workshops, :reservation_allow
    remove_column :workshops, :reservation_allow_multiple
    remove_column :workshops, :reservation_minimum
    remove_column :workshops, :reservation_maximum

    drop_table :workshop_types
  end
end
