class AddInvoiceNumberSequence < ActiveRecord::Migration[5.2]
  def up
    execute 'CREATE SEQUENCE IF NOT EXISTS invoices_invoice_number_seq INCREMENT BY 1 START WITH 1000 OWNED BY invoices.invoice_number'
    execute "ALTER TABLE invoices ALTER COLUMN invoice_number SET DEFAULT nextval('invoices_invoice_number_seq')"
  end

  def down
    execute 'DROP SEQUENCE IF EXISTS invoices_invoice_number_seq'
    execute 'ALTER TABLE invoices ALTER COLUMN invoice_number DROP DEFAULT'
  end
end
