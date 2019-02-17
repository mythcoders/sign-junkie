class TheGreatRefactoring < ActiveRecord::Migration[5.2]
  def change
    remove_reference :payments, :order
    remove_column :payments, :memo, type: :string, limit: 100
    remove_column :payments, :date_created, type: :datetime, null: false, default: -> { 'clock_timestamp()' }
    remove_column :payments, :date_cleared, :datetime
    remove_column :payments, :date_posted, :datetime
    remove_column :payments, :status, :integer, default: 0, null: false
    rename_column :payments, :transaction_id, :identifier
    add_column :payments, :tax_rate, :decimal, null: false
    add_column :payments, :tax_amount, :decimal, null: false

    add_column :orders, :status, :string, null: false
    remove_column :orders, :tax_rate, :integer, null: false
    remove_column :orders, :date_fulfilled, :datetime
    remove_column :orders, :date_closed, :datetime
    remove_column :orders, :payment_method, :string
    remove_reference :orders, :address

    add_reference :order_items, :payment
    add_reference :order_items, :workshop, null: false
    add_reference :order_items, :user, null: false
    rename_column :order_items, :deposit, :for_deposit
    add_column :order_items, :notified, :boolean
    add_column :order_items, :prepped, :boolean
    remove_column :order_items, :quantity, :integer, null: false
    add_column :order_items, :identifier, :string
    add_column :order_items, :seating, :string
    add_column :order_items, :design, :string

    add_reference :cart_items, :design
    remove_column :cart_items, :design, :string
    remove_column :cart_items, :session_id, :string, null: false
    add_column :cart_items, :price, :decimal, null: false

    drop_table :tickets
    drop_table :addresses
    drop_table :order_notes
    drop_table :notes
  end
end
