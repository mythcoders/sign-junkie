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

ActiveRecord::Schema.define(version: 2019_02_17_033648) do

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

  create_table "addons", force: :cascade do |t|
    t.bigint "project_id"
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_addons_on_project_id"
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
    t.integer "quantity", default: 1, null: false
    t.bigint "workshop_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id"
    t.bigint "addon_id"
    t.bigint "design_id"
    t.decimal "price", null: false
    t.index ["addon_id"], name: "index_cart_items_on_addon_id"
    t.index ["design_id"], name: "index_cart_items_on_design_id"
    t.index ["project_id"], name: "index_cart_items_on_project_id"
    t.index ["user_id"], name: "index_cart_items_on_user_id"
    t.index ["workshop_id"], name: "index_cart_items_on_workshop_id"
  end

  create_table "design_categories", force: :cascade do |t|
    t.string "name", null: false
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "designs", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "design_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_category_id"], name: "index_designs_on_design_category_id"
    t.index ["name", "design_category_id"], name: "index_designs_on_name_and_design_category_id", unique: true
  end

  create_table "order_items", id: :serial, force: :cascade do |t|
    t.string "addon"
    t.bigint "order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "for_deposit", default: false, null: false
    t.bigint "payment_id"
    t.bigint "workshop_id", null: false
    t.boolean "notified"
    t.boolean "prepped"
    t.string "identifier"
    t.string "seating"
    t.string "design"
    t.decimal "price", default: "0.0", null: false
    t.bigint "user_id"
    t.string "project"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["payment_id"], name: "index_order_items_on_payment_id"
    t.index ["user_id"], name: "index_order_items_on_user_id"
    t.index ["workshop_id"], name: "index_order_items_on_workshop_id"
  end

  create_table "orders", id: :serial, force: :cascade do |t|
    t.serial "order_number", limit: 10
    t.datetime "date_placed"
    t.datetime "date_canceled"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", null: false
    t.datetime "date_created", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.string "identifier", limit: 25
    t.string "method", null: false
    t.decimal "amount"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "tax_rate", null: false
    t.decimal "tax_amount", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "project_designs", force: :cascade do |t|
    t.bigint "design_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["design_id", "project_id"], name: "index_project_designs_on_design_id_and_project_id", unique: true
    t.index ["design_id"], name: "index_project_designs_on_design_id"
    t.index ["project_id"], name: "index_project_designs_on_project_id"
  end

  create_table "project_workshops", force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "workshop_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_workshops_on_project_id"
    t.index ["workshop_id"], name: "index_project_workshops_on_workshop_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "workshops", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description", limit: 500
    t.datetime "purchase_start_date", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date"
    t.integer "total_tickets", default: 0, null: false
    t.decimal "ticket_price", null: false
    t.boolean "is_for_sale", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_public", default: true, null: false
    t.datetime "purchase_end_date"
  end

  add_foreign_key "cart_items", "addons"
  add_foreign_key "cart_items", "projects"
  add_foreign_key "cart_items", "users"
  add_foreign_key "cart_items", "workshops"
  add_foreign_key "design_categories", "design_categories", column: "parent_id"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "users", name: "order_items_user_id_fkey"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "users"
end
