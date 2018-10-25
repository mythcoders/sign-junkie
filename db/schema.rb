# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_10_24_010218) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "nickname", limit: 25
    t.string "street", limit: 30, null: false
    t.string "street2", limit: 30
    t.string "city", limit: 25, null: false
    t.string "state", limit: 2, null: false
    t.string "zip_code", limit: 9, null: false
    t.string "country", limit: 3, null: false
    t.boolean "is_default", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_id", "associated_type"], name: "associated_index"
    t.index ["auditable_id", "auditable_type"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "cart_items", id: :serial, force: :cascade do |t|
    t.string "session_id"
    t.integer "quantity", default: 1, null: false
    t.bigint "event_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_cart_items_on_event_id"
    t.index ["user_id"], name: "index_cart_items_on_user_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description", limit: 500
    t.datetime "posting_start_date", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.integer "tickets_available", default: 0, null: false
    t.decimal "ticket_price", null: false
    t.boolean "is_for_sale", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "author_id", null: false
    t.string "content", limit: 500
    t.boolean "is_flagged"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.decimal "price", default: "0.0", null: false
    t.integer "quantity", null: false
    t.boolean "is_overridden", default: false, null: false
    t.decimal "overridden_amount"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
  end

  create_table "order_notes", id: :serial, force: :cascade do |t|
    t.integer "author_id", null: false
    t.string "content", limit: 500, null: false
    t.boolean "is_printed", null: false
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_notes_on_order_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.serial "order_number", limit: 10
    t.datetime "date_created", default: -> { "clock_timestamp()" }, null: false
    t.datetime "date_placed"
    t.datetime "date_fulfilled"
    t.datetime "date_canceled"
    t.decimal "tax_rate", default: "0.0", null: false
    t.bigint "user_id"
    t.bigint "address_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.datetime "date_closed"
    t.index ["address_id"], name: "index_orders_on_address_id"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.string "memo", limit: 100
    t.string "transaction_id", limit: 25
    t.string "method", null: false
    t.decimal "amount"
    t.datetime "date_created", default: -> { "clock_timestamp()" }, null: false
    t.datetime "date_posted"
    t.datetime "date_cleared"
    t.integer "status", default: 0, null: false
    t.bigint "user_id"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "middle_name", limit: 25
    t.string "last_name", limit: 50, null: false
    t.string "phone_number", limit: 10
    t.string "role", default: "customer", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "cart_items", "events"
  add_foreign_key "cart_items", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "notes", "users", column: "author_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_notes", "orders"
  add_foreign_key "order_notes", "users", column: "author_id"
  add_foreign_key "orders", "addresses"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "payments", "users"
end
