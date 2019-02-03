class CreateTickets < ActiveRecord::Migration[5.2]
  def change
    create_table :tickets do |t|
      t.references :workshop, index: true, foreign_key: true, null: false
      t.references :user, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true
      t.references :addon, index: true, foreign_key: true
      t.references :order_item, index: true, foreign_key: true
      t.string :identifier, null: false, length: 25
      t.boolean :notified, null: false, default: false
      t.timestamps
    end

    change_table :order_items do |t|
      t.boolean :deposit, default: false, null: false
      t.remove :identifier
      t.remove_references :workshop
      t.remove_references :user
    end
  end
end
