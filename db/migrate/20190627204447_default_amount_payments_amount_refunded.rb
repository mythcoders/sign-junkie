# frozen_string_literal: true

class DefaultAmountPaymentsAmountRefunded < ActiveRecord::Migration[5.2]
  def change
    change_column :payments, :amount_refunded, :decimal, default: 0.00
  end
end
