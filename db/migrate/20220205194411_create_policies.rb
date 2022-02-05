class CreatePolicies < ActiveRecord::Migration[7.0]
  def change
    create_table :policies do |t|
      t.string :name
      t.string :slug
      t.string :title
      t.timestamps
    end

    add_index :policies, :name, unique: true
    add_index :policies, :slug, unique: true

    add_reference :workshop_types, :guest_policy, foreign_key: {to_table: :policies}, index: true
    add_reference :workshop_types, :host_policy, foreign_key: {to_table: :policies}, index: true
  end
end
