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

ActiveRecord::Schema.define(version: 2020_09_10_191151) do

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

  create_table "addons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_addons_on_name", unique: true
  end

  create_table "carts", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_description_id", null: false
    t.index ["item_description_id"], name: "index_carts_on_item_description_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "address_1"
    t.string "address_2"
    t.string "state"
    t.string "city"
    t.string "zip_code"
    t.string "phone"
    t.string "fax"
    t.string "contact_email"
    t.string "instagram_account"
    t.string "facebook_account"
    t.string "twitter_account"
    t.string "site_url"
    t.string "site_name"
    t.string "site_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_credits", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "starting_amount", null: false
    t.date "expiration_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "balance", default: "0.0", null: false
    t.index ["user_id"], name: "index_customer_credits_on_user_id"
  end

  create_table "gallery_images", force: :cascade do |t|
    t.string "caption"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "invoice_items", id: :serial, force: :cascade do |t|
    t.bigint "invoice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_description_id", null: false
    t.index ["invoice_id"], name: "index_invoice_items_on_invoice_id"
    t.index ["item_description_id"], name: "index_invoice_items_on_item_description_id"
  end

  create_table "invoices", id: :serial, force: :cascade do |t|
    t.bigint "user_id"
    t.serial "identifier", null: false
    t.string "status"
    t.date "due_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_invoices_on_user_id"
  end

  create_table "item_descriptions", force: :cascade do |t|
    t.string "item_type", null: false
    t.string "identifier", null: false
    t.decimal "taxable_amount", null: false
    t.decimal "nontaxable_amount", null: false
    t.decimal "tax_amount", null: false
    t.decimal "tax_rate"
    t.datetime "cancel_date"
    t.datetime "void_date"
    t.integer "workshop_id"
    t.string "workshop_name"
    t.integer "project_id"
    t.string "project_name"
    t.integer "stencil_id"
    t.string "stencil_name"
    t.string "stencil_personalization"
    t.integer "addon_id"
    t.string "addon_name"
    t.string "seat_preference"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_plan"
    t.datetime "refund_date"
    t.boolean "for_child", default: false
    t.boolean "gifted", default: false
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
    t.decimal "amount_refunded", default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "project_addons", id: :serial, force: :cascade do |t|
    t.bigint "project_id"
    t.bigint "addon_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addon_id"], name: "index_project_addons_on_addon_id"
    t.index ["project_id", "addon_id"], name: "index_project_addons_on_project_id_and_addon_id", unique: true
  end

  create_table "project_stencils", id: :serial, force: :cascade do |t|
    t.bigint "stencil_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_project_stencils_on_project_id"
    t.index ["stencil_id", "project_id"], name: "index_project_stencils_on_stencil_id_and_project_id", unique: true
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "instructional_price"
    t.decimal "material_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "allow_no_stencil", default: false, null: false
    t.integer "allowed_stencils", default: 1
    t.boolean "active", default: true, null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_description_id", null: false
    t.boolean "forfeit_deposit", default: false
    t.index ["user_id"], name: "index_reservations_on_user_id"
    t.index ["workshop_id"], name: "index_reservations_on_workshop_id"
  end

  create_table "seats", id: :serial, force: :cascade do |t|
    t.bigint "workshop_id"
    t.bigint "reservation_id"
    t.bigint "user_id"
    t.boolean "prepped"
    t.boolean "notified"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "item_description_id", null: false
    t.index ["reservation_id"], name: "index_seats_on_reservation_id"
    t.index ["user_id"], name: "index_seats_on_user_id"
    t.index ["workshop_id", "user_id", "item_description_id"], name: "index_seats_on_workshop_id_and_user_id_and_item_description_id", unique: true
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
    t.boolean "allow_personilization", default: false
    t.boolean "active", default: true, null: false
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
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "workshop_projects", id: :serial, force: :cascade do |t|
    t.bigint "workshop_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_workshop_projects_on_project_id"
    t.index ["workshop_id", "project_id"], name: "index_workshop_projects_on_workshop_id_and_project_id", unique: true
  end

  create_table "workshop_types", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.boolean "default_reservation_allow"
    t.boolean "default_reservation_allow_multiple"
    t.integer "default_total_seats"
    t.decimal "default_reservation_price"
    t.integer "default_reservation_minimum"
    t.integer "default_reservation_maximum"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "default_single_seat_allow"
    t.boolean "default_reservation_cancel_minimum_not_met"
    t.boolean "default_reservation_allow_guest_cancel_seat", default: true
  end

  create_table "workshops", id: :serial, force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "description", limit: 1000
    t.datetime "purchase_start_date"
    t.datetime "purchase_end_date"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "overridden_total_seats"
    t.decimal "overridden_reservation_price"
    t.boolean "is_for_sale", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "cancel_date"
    t.integer "workshop_type_id", null: false
    t.boolean "overridden_reservation_allow"
    t.boolean "overridden_reservation_allow_multiple"
    t.integer "overridden_reservation_minimum"
    t.integer "overridden_reservation_maximum"
    t.boolean "overridden_single_seat_allow"
    t.boolean "overridden_reservation_cancel_minimum_not_met"
    t.boolean "overridden_reservation_allow_guest_cancel_seat"
    t.boolean "family_friendly", default: false
  end

  add_foreign_key "carts", "item_descriptions"
  add_foreign_key "carts", "users"
  add_foreign_key "customer_credits", "users"
  add_foreign_key "invoice_items", "invoices"
  add_foreign_key "invoice_items", "item_descriptions"
  add_foreign_key "invoices", "users"
  add_foreign_key "notifiications", "users"
  add_foreign_key "payments", "invoices"
  add_foreign_key "project_addons", "addons"
  add_foreign_key "project_addons", "projects"
  add_foreign_key "project_stencils", "projects"
  add_foreign_key "project_stencils", "stencils"
  add_foreign_key "refunds", "customer_credits"
  add_foreign_key "refunds", "invoices"
  add_foreign_key "refunds", "refund_reasons"
  add_foreign_key "reservations", "item_descriptions"
  add_foreign_key "reservations", "users"
  add_foreign_key "reservations", "workshops"
  add_foreign_key "seats", "item_descriptions"
  add_foreign_key "seats", "reservations"
  add_foreign_key "seats", "users"
  add_foreign_key "seats", "workshops"
  add_foreign_key "stencil_categories", "stencil_categories", column: "parent_id"
  add_foreign_key "stencils", "stencil_categories"
  add_foreign_key "workshop_projects", "projects"
  add_foreign_key "workshop_projects", "workshops"
  add_foreign_key "workshops", "workshop_types"
end
