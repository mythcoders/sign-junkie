# frozen_string_literal: true

class Initial < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      #t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at

      t.timestamps
    end

    # add_index :users, :customer_id, unique: true
    # add_index :users, :employee_id, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
    # add_index :users, :unlock_token, unique: true # if unlock strategy is :email or :both

    create_table :events, id: :serial do |t|
      t.string :name, null: false
      t.string :description
      t.datetime :start_date, null: false
      t.datetime :end_date
      t.integer :tickets_available
      t.decimal :ticket_price
      t.boolean :is_for_sale, null: false, default: false
      t.timestamps
    end

    create_table :customers, id: :serial do |t|
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.string :phone_number
      t.references :users, index: true, foreign_key: true
      t.timestamps
    end

    create_table :addresses, id: :serial do |t|
      t.string :nickname
      t.string :street, null: false
      t.string :street2
      t.string :city, null: false
      t.string :state, null: false
      t.string :zip_code, null: false
      t.string :country, null: false
      t.boolean :is_default, null: false
      t.references :customers, index: true, foreign_key: true
      t.timestamps
    end

    create_table :notes, id: :serial do |t|
      t.string :author
      t.string :content
      t.boolean :is_flagged
      t.references :customers, index: true, foreign_key: true
      t.timestamps
    end

    create_table :cart_items, id: :serial do |t|
      t.string :session_id, null: true
      t.integer :quantity, null: false, default: 1
      t.references :events, index: true, foreign_key: true
      t.references :customers, index: true, foreign_key: true
      t.timestamps
    end

    create_table :orders, id: :serial do |t|
      t.string :order_number
      t.datetime :date_created, null: false, default: -> { 'CLOCK_TIMESTAMP()' }
      t.datetime :date_placed
      t.datetime :date_fulfilled
      t.datetime :date_canceled
      t.decimal :tax_rate, default: 0.00, null: false
      t.references :customers, index: true, foreign_key: true
      t.references :addresses, index: true, foreign_key: true
      t.timestamps
    end

    create_table :order_items, id: :serial do |t|
      t.string :name, null: false
      t.decimal :price, default: 0.00, null: false
      t.integer :quantity, null: false
      t.boolean :is_overridden, default: false, null: false
      t.decimal :overridden_amount, null: true
      t.references :orders, index: true, foreign_key: true
      t.timestamps
    end

    create_table :order_notes, id: :serial do |t|
      t.string :author, null: false
      t.string :content, null: false
      t.boolean :is_printed, null: false
      t.references :orders, index: true, foreign_key: true
      t.timestamps
    end

    create_table :payments, id: :serial do |t|
      t.string :memo
      t.string :transaction_id
      t.string :method, null: false
      t.decimal :amount
      t.datetime :date_posted, null: true
      t.datetime :date_cleared, null: true
      t.integer :status, null: false, default: 0
      t.references :user, index: true, foreign_key: true
      t.references :orders, index: true, foreign_key: true
      t.timestamps
    end
  end
end
