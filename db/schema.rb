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

ActiveRecord::Schema.define(version: 2018_08_14_232913) do

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

  create_table "carts", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.string "description", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "customer_credits", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "amount", null: false
    t.datetime "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customer_credits_on_user_id"
  end

  create_table "invoice_items", id: :serial, force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "description", null: false
    t.decimal "pre_tax_amount", default: "0.0", null: false
    t.integer "quantity", null: false
    t.decimal "tax_rate"
    t.decimal "tax_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.serial "identifier", limit: 10
    t.string "status"
    t.date "due_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "notifiications", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.string "memo"
    t.datetime "read_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifiications_on_user_id"
  end

  create_table "payments", id: :serial, force: :cascade do |t|
    t.bigint "invoice_id"
    t.string "identifier", limit: 25
    t.string "method", null: false
    t.decimal "amount", null: false
    t.decimal "amount_refunded"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "project_addons", id: :serial, force: :cascade do |t|
    t.bigint "project_id"
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "name"], name: "index_project_addons_on_project_id_and_name", unique: true
    t.index ["project_id"], name: "index_project_addons_on_project_id"
  end

  create_table "project_stencils", id: :serial, force: :cascade do |t|
    t.bigint "stencil_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_stencils_on_project_id"
    t.index ["stencil_id", "project_id"], name: "index_project_stencils_on_stencil_id_and_project_id", unique: true
    t.index ["stencil_id"], name: "index_project_stencils_on_stencil_id"
  end

  create_table "project_workshops", id: :serial, force: :cascade do |t|
    t.bigint "project_id", null: false
    t.bigint "workshop_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "workshop_id"], name: "index_project_workshops_on_project_id_and_workshop_id", unique: true
    t.index ["project_id"], name: "index_project_workshops_on_project_id"
    t.index ["workshop_id"], name: "index_project_workshops_on_workshop_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_projects_on_name", unique: true
  end

  create_table "refund_reasons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "is_active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refunds", id: :serial, force: :cascade do |t|
    t.bigint "invoice_id"
    t.bigint "customer_credit_id"
    t.bigint "refund_reason_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_credit_id"], name: "index_refunds_on_customer_credit_id"
    t.index ["invoice_id"], name: "index_refunds_on_invoice_id"
    t.index ["refund_reason_id"], name: "index_refunds_on_refund_reason_id"
  end

  create_table "reservations", id: :serial, force: :cascade do |t|
    t.bigint "workshop_id"
    t.bigint "user_id"
    t.serial "identifier", limit: 10
    t.string "payment_plan", null: false
    t.datetime "void_date"
    t.datetime "cancel_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.index ["workshop_id"], name: "index_reservations_on_workshop_id"
  end

  create_table "seats", id: :serial, force: :cascade do |t|
    t.bigint "workshop_id"
    t.bigint "reservation_id"
    t.bigint "user_id"
    t.bigint "invoice_id"
    t.string "identifier"
    t.string "description"
    t.boolean "prepped"
    t.boolean "notified"
    t.datetime "void_date"
    t.datetime "cancel_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_seats_on_invoice_id"
    t.index ["reservation_id"], name: "index_seats_on_reservation_id"
    t.index ["user_id"], name: "index_seats_on_user_id"
    t.index ["workshop_id"], name: "index_seats_on_workshop_id"
  end

  create_table "stencil_categories", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stencils", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.bigint "stencil_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "stencil_category_id"], name: "index_stencils_on_name_and_stencil_category_id", unique: true
    t.index ["stencil_category_id"], name: "index_stencils_on_stencil_category_id"
  end

  create_table "system_settings", id: :serial, force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tax_periods", id: :serial, force: :cascade do |t|
    t.datetime "start_date", null: false
    t.datetime "due_date", null: false
    t.decimal "estimated_due"
    t.decimal "amount_paid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tax_rates", id: :serial, force: :cascade do |t|
    t.decimal "rate", null: false
    t.datetime "effective_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
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
    t.string "description", limit: 1000
    t.datetime "purchase_start_date"
    t.datetime "purchase_end_date"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "total_tickets"
    t.decimal "ticket_price"
    t.decimal "deposit_price"
    t.boolean "is_for_sale", default: false, null: false
    t.boolean "is_public", default: true, null: false
    t.boolean "allow_custom_projects", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "carts", "users"
  add_foreign_key "customer_credits", "users"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoices", "users"
  add_foreign_key "notifiications", "users"
  add_foreign_key "payments", "invoices"
  add_foreign_key "project_addons", "projects"
  add_foreign_key "project_stencils", "projects"
  add_foreign_key "project_stencils", "stencils"
  add_foreign_key "project_workshops", "projects"
  add_foreign_key "project_workshops", "workshops"
  add_foreign_key "refunds", "customer_credits"
  add_foreign_key "refunds", "invoices"
  add_foreign_key "refunds", "refund_reasons"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "workshops"
  add_foreign_key "seats", "invoices"
  add_foreign_key "seats", "reservations"
  add_foreign_key "seats", "users"
  add_foreign_key "seats", "workshops"
  add_foreign_key "stencil_categories", "stencil_categories", column: "parent_id"
  add_foreign_key "stencils", "stencil_categories"
end
