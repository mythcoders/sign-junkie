class CreateProjectCustomizations < ActiveRecord::Migration[5.2]
  def change
    create_table :customizations do |t|
      t.string :name
      t.string :category
      t.index [:name, :category], unique: true
      t.timestamps
    end

    create_table :project_customizations do |t|
      t.references :customization
      t.references :project
      t.index [:customization_id, :project_id], unique: true
      t.timestamps
    end

    change_table :cart_items do |t|
      t.string :customization, null: false, default: '?'
      t.change :project_id, :integer, null: false
    end

    add_column :tickets, :customization, :string
  end
end
