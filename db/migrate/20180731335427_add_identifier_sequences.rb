# frozen_string_literal: true

class AddIdentifierSequences < ActiveRecord::Migration[5.2]
  def up
    execute "CREATE SEQUENCE IF NOT EXISTS invoices_identifier_seq INCREMENT BY 1 START WITH 1000 OWNED BY invoices.identifier"
    execute "ALTER TABLE invoices ALTER COLUMN identifier SET DEFAULT nextval('invoices_identifier_seq')"

    execute "CREATE SEQUENCE IF NOT EXISTS reservations_identifier_seq INCREMENT BY 1 START WITH 1 OWNED BY invoices.identifier"
    execute "ALTER TABLE reservations ALTER COLUMN identifier SET DEFAULT nextval('reservations_identifier_seq')"
  end

  def down
    execute "DROP SEQUENCE IF EXISTS invoices_identifier_seq"
    execute "ALTER TABLE invoices ALTER COLUMN identifier DROP DEFAULT"
    execute "DROP SEQUENCE IF EXISTS reservations_identifier_seq"
    execute "ALTER TABLE reservations ALTER COLUMN identifier DROP DEFAULT"
  end
end
