class CreateItemDescriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :item_descriptions do |t|
      # all items
      t.string :item_type, null: false
      t.string :identifier, null: false
      t.decimal :taxable_amount, null: false
      t.decimal :nontaxable_amount, null: false
      t.decimal :tax_amount, null: false
      t.decimal :tax_rate
      t.datetime :cancel_date
      t.datetime :void_date

      # reservations and seats
      t.integer :workshop_id
      t.string :workshop_name

      # seats
      t.integer :project_id
      t.string :project_name
      t.integer :stencil_id
      t.string :stencil_name
      t.string :stencil_personalization
      t.integer :addon_id
      t.string :addon_name
      t.string :seat_preference

      # reservations
      t.integer :seats_booked

      # gift_cards and gifted seats
      t.string :first_name
      t.string :last_name
      t.string :email

      t.timestamps
    end

    remove_column :carts, :description, :string
    remove_column :carts, :price, :decimal
    remove_column :carts, :quantity, :integer
    remove_column :invoice_items, :description, :string
    remove_column :invoice_items, :pre_tax_amount, :decimal
    remove_column :invoice_items, :tax_rate, :decimal
    remove_column :invoice_items, :tax_amount, :decimal
    remove_column :invoice_items, :quantity, :integer
    remove_column :seats, :cancel_date, :datetime
    remove_column :seats, :description, :string
    remove_column :seats, :identifier, :string
    remove_column :seats, :invoice_id, :integer
    remove_column :seats, :void_date, :datetime
    remove_column :reservations, :cancel_date, :datetime
    remove_column :reservations, :identifier, :string
    remove_column :reservations, :void_date, :datetime

    add_column :carts, :item_description_id, :integer, null: false
    add_column :invoice_items, :item_description_id, :integer, null: false
    add_column :seats, :item_description_id, :integer, null: false
    add_column :reservations, :item_description_id, :integer, null: false

    add_foreign_key :carts, :item_descriptions
    add_foreign_key :invoice_items, :item_descriptions
    add_foreign_key :reservations, :item_descriptions
    add_foreign_key :seats, :item_descriptions
  end
end
