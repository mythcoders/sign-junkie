# frozen_string_literal: true

class RemoveTimeFromCreditExpiration < ActiveRecord::Migration[5.2]
  def change
    change_table :customer_credits do |t|
      t.decimal :balance, null: false, default: 0
      t.rename :amount, :starting_amount
    end

    change_column_null :customer_credits, :starting_amount, false

    reversible do |dir|
      dir.up do
        change_column :customer_credits, :expiration_date, :date
      end
      dir.down do
        change_column :customer_credits, :expiration_date, :datetime
      end
    end
  end
end
