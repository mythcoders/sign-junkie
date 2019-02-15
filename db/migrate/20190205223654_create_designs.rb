class CreateDesigns < ActiveRecord::Migration[5.2]
  def change
    create_table :designs do |t|
      t.string :name, null: false
      t.references :design_category, null: false
      t.index [:name, :design_category_id], unique: true
      t.timestamps
    end

    create_table :design_categories do |t|
      t.string :name, null: false
      t.integer :parent_id, null: true
      t.foreign_key :design_categories, column: :parent_id
      t.timestamps
    end

    create_table :project_designs do |t|
      t.references :design, null: false
      t.references :project, null: false
      t.index [:design_id, :project_id], unique: true
      t.timestamps
    end

    add_column :cart_items, :design, :string
    add_column :tickets, :design, :string
  end
end
