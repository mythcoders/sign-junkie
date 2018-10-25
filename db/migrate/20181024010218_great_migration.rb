class GreatMigration < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :date_closed, :datetime, null: true
    change_column :events, :tickets_available, :integer, null: false, default: 0
    change_column :events, :ticket_price, :decimal, null: false
  end
end
