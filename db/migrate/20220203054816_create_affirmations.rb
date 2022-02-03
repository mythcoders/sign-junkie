class CreateAffirmations < ActiveRecord::Migration[7.0]
  def change
    create_table :affirmations do |t|
      t.string :title, null: false
      t.references :workshop_type, foreign_key: true, index: true, null: false
      t.boolean :active, null: false, default: true
      t.boolean :for_seats, null: false, default: true
      t.boolean :for_reservations, null: false, default: false
      t.timestamps
    end
  end
end
