class AddOrderNumberSequence < ActiveRecord::Migration[5.2]
  def up
    execute 'CREATE SEQUENCE IF NOT EXISTS orders_order_number_seq INCREMENT BY 1 START WITH 1000 OWNED BY orders.order_number'
    execute "ALTER TABLE orders ALTER COLUMN order_number SET DEFAULT nextval('orders_order_number_seq')"
  end

  def down
    execute 'DROP SEQUENCE IF EXISTS orders_order_number_seq'
    execute 'ALTER TABLE orders ALTER COLUMN order_number DROP DEFAULT'
  end
end
