# frozen_string_literal: true

class Initial < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false, limit: 50
      t.string :middle_name, limit: 25
      t.string :last_name, null: false, limit: 50
      t.string :phone_number, limit: 10
      t.string :role, null: false, default: 'customer'
      t.string   :email,              null: false, default: ''
      t.string   :encrypted_password, null: false, default: ''
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
      t.integer  :failed_attempts, default: 0, null: false
      t.datetime :locked_at
      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true

    create_table :events, id: :serial do |t|
      t.string :name, null: false, limit: 50
      t.string :description, limit: 500
      t.datetime :posting_start_date, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.integer :tickets_available
      t.decimal :ticket_price
      t.boolean :is_for_sale, null: false, default: false
      t.timestamps
    end

    create_table :addresses, id: :serial do |t|
      t.string :nickname, limit: 25
      t.string :street, null: false, limit: 30
      t.string :street2, limit: 30
      t.string :city, null: false, limit: 25
      t.string :state, null: false, limit: 2
      t.string :zip_code, null: false, limit: 9
      t.string :country, null: false, limit: 3
      t.boolean :is_default, null: false
      t.references :users, index: true, foreign_key: true
      t.timestamps
    end

    create_table :notes, id: :serial do |t|
      t.string :author
      t.string :content, limit: 500
      t.boolean :is_flagged
      t.references :users, index: true, foreign_key: true
      t.timestamps
    end

    create_table :cart_items, id: :serial do |t|
      t.string :session_id, null: true
      t.integer :quantity, null: false, default: 1
      t.references :events, index: true, foreign_key: true
      t.references :users, index: true, foreign_key: true
      t.timestamps
    end

    create_table :orders, id: :serial do |t|
      t.string :order_number, limit: 10
      t.datetime :date_created, null: false, default: -> { 'CLOCK_TIMESTAMP()' }
      t.datetime :date_placed
      t.datetime :date_fulfilled
      t.datetime :date_canceled
      t.decimal :tax_rate, default: 0.00, null: false
      t.references :users, index: true, foreign_key: true
      t.references :addresses, index: true, foreign_key: true
      t.timestamps
    end

    create_table :order_items, id: :serial do |t|
      t.string :name, null: false, limit: 50
      t.decimal :price, default: 0.00, null: false
      t.integer :quantity, null: false
      t.boolean :is_overridden, default: false, null: false
      t.decimal :overridden_amount, null: true
      t.references :orders, index: true, foreign_key: true
      t.timestamps
    end

    create_table :order_notes, id: :serial do |t|
      t.string :author, null: false
      t.string :content, null: false, limit: 500
      t.boolean :is_printed, null: false
      t.references :orders, index: true, foreign_key: true
      t.timestamps
    end

    create_table :payments, id: :serial do |t|
      t.string :memo, limit: 100
      t.string :transaction_id, limit: 25
      t.string :method, null: false
      t.decimal :amount
      t.datetime :date_created, null: false, default: -> { 'CLOCK_TIMESTAMP()' }
      t.datetime :date_posted
      t.datetime :date_cleared
      t.integer :status, null: false, default: 0
      t.references :users, index: true, foreign_key: true
      t.references :orders, index: true, foreign_key: true
      t.timestamps
    end
  end
end
