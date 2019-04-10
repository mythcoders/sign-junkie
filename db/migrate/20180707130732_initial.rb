# frozen_string_literal: true

class Initial < ActiveRecord::Migration[5.2]
  def change
    # Core module
    create_table :users do |t|
      t.string   :first_name, null: false, limit: 50
      t.string   :last_name, null: false, limit: 50
      t.string   :role, null: false, default: 'customer'
      t.string   :email, null: false, default: ''
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

    create_table :tax_rates, id: :serial do |t|
      t.decimal :rate, null: false
      t.datetime :effective_date, null: false
      t.timestamps
    end

    create_table :tax_periods, id: :serial do |t|
      t.datetime :start_date, null: false
      t.datetime :due_date, null: false
      t.decimal :estimated_due
      t.decimal :amount_paid, null: false
      t.timestamps
    end

    create_table :workshops, id: :serial do |t|
      t.string :name, null: false, limit: 50
      t.string :description, limit: 1000
      t.datetime :purchase_start_date
      t.datetime :purchase_end_date
      t.datetime :start_date
      t.datetime :end_date
      t.integer :total_tickets
      t.decimal :reservation_price
      t.boolean :is_for_sale, null: false, default: false
      t.boolean :is_public, null: false, default: true
      t.boolean :allow_custom_stencils, null: false, default: false
      t.timestamps
    end

    create_table :stencil_categories, id: :serial do |t|
      t.string :name, null: false
      t.integer :parent_id, null: true
      t.foreign_key :stencil_categories, column: :parent_id
      t.timestamps
    end

    create_table :stencils, id: :serial do |t|
      t.string :name, null: false
      t.references :stencil_category, foreign_key: true, null: false
      t.index [:name, :stencil_category_id], unique: true
      t.timestamps
    end

    create_table :addons, id: :serial do |t|
      t.string :name
      t.decimal :price
      t.index [:name], unique: true
      t.timestamps
    end

    create_table :projects, id: :serial do |t|
      t.string :name
      t.string :description
      t.decimal :instructional_price
      t.decimal :material_price
      t.index [:name], unique: true
      t.timestamps
    end

    create_table :project_addons, id: :serial do |t|
      t.references :project, foreign_key: true
      t.references :addon, foreign_key: true
      t.index [:project_id, :addon_id], unique: true
      t.timestamps
    end

    create_table :project_stencils, id: :serial do |t|
      t.references :stencil, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.index [:stencil_id, :project_id], unique: true
      t.timestamps
    end

    create_table :workshop_projects, id: :serial do |t|
      t.references :workshop, foreign_key: true, null: false
      t.references :project, foreign_key: true, null: false
      t.index [:workshop_id, :project_id], unique: true
      t.timestamps
    end

    create_table :carts, id: :serial do |t|
      t.references :user, index: true, foreign_key: true
      t.string :description, null: false
      t.integer :quantity, null: false, default: 1
      t.decimal :price, null: false
      t.timestamps
    end

    create_table :invoices, id: :serial do |t|
      t.references :user, index: true, foreign_key: true
      t.string :identifier, limit: 10
      t.string :status
      t.date :due_date, null: false
      t.timestamps
    end

    create_table :invoice_items, id: :serial do |t|
      t.references :invoice, index: true, foreign_key: true
      t.string :description, null: false
      t.decimal :pre_tax_amount, default: 0.00, null: false
      t.integer :quantity, null: false
      t.decimal :tax_rate
      t.decimal :tax_amount
      t.timestamps
    end

    create_table :payments, id: :serial do |t|
      t.references :invoice, index: true, foreign_key: true
      t.string :identifier, limit: 25
      t.string :method, null: false
      t.decimal :amount, null: false
      t.decimal :amount_refunded, default: nil
      t.timestamps
    end

    create_table :refund_reasons, id: :serial do |t|
      t.string :name
      t.boolean :is_active
      t.timestamps
    end

    create_table :customer_credits, id: :serial do |t|
      t.references :user, index: true, foreign_key: true
      t.decimal :amount, null: false
      t.datetime :expiration_date
      t.timestamps
    end

    create_table :refunds, id: :serial do |t|
      t.references :invoice, index: true, foreign_key: true
      t.references :customer_credit, foreign_key: true
      t.references :refund_reason, foreign_key: true
      t.decimal :amount
      t.timestamps
    end

    create_table :reservations, id: :serial do |t|
      t.references :workshop, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :identifier, limit: 10
      t.string :payment_plan, null: false
      t.datetime :void_date
      t.datetime :cancel_date
      t.timestamps
    end

    create_table :seats, id: :serial do |t|
      t.references :workshop, index: true, foreign_key: true
      t.references :reservation, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :invoice, index: true, foreign_key: true
      t.string :identifier
      t.string :description
      t.boolean :prepped
      t.boolean :notified
      t.datetime :void_date
      t.datetime :cancel_date
      t.timestamps
    end

    create_table :system_settings, id: :serial do |t|
      t.string :key
      t.string :value
      t.timestamps
    end

    create_table :notifiications, id: :serial do |t|
      t.references :user, index: true, foreign_key: true
      t.string :title
      t.string :memo
      t.datetime :read_date
      t.timestamps
    end
  end
end
