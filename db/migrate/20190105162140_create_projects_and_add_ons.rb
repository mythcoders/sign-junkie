class CreateProjectsAndAddOns < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    create_table :addons do |t|
      t.references :project
      t.string :name
      t.decimal :price
      t.timestamps
    end

    create_table :project_workshops do |t|
      t.references :project
      t.references :workshop
      t.timestamps
    end

    change_table :order_items do |t|
      t.string :identifier, null: false, length: 25
      t.remove :is_overridden, :overridden_amount
    end

    create_table :attendees do |t|
      t.references :workshop
      t.string :name
      t.string :email_address
      t.string :project_description
      t.timestamps
    end

    change_table :workshops do |t|
      t.boolean :is_public, null: false, default: true
      t.datetime :posting_end_date
    end
  end
end
