class CreateColors < ActiveRecord::Migration[7.0]
  def change
    create_table :colors do |t|
      t.string :name, null: false
      t.string :color_type, null: false
      t.string :hex_code, null: false
      t.boolean :active, default: true
      t.timestamps
    end

    create_table :project_colors do |t|
      t.belongs_to :project
      t.belongs_to :color
    end
  end
end
