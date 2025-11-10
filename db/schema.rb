# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_11_10_111941) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accommodations", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "street_address"
    t.string "street_address_2"
    t.string "city"
    t.string "region"
    t.string "postal_code"
    t.string "country"
    t.string "email"
    t.string "phone"
    t.date "check_in"
    t.date "check_out"
    t.integer "adults"
    t.integer "children"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "tenant_id", null: false
    t.bigint "property_id", null: false
    t.date "start_date"
    t.date "end_date"
    t.string "status"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_bookings_on_property_id"
    t.index ["tenant_id"], name: "index_bookings_on_tenant_id"
  end

  create_table "cable_messages", force: :cascade do |t|
    t.string "channel"
    t.text "payload"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.index ["channel"], name: "index_cable_messages_on_channel"
    t.index ["expires_at"], name: "index_cable_messages_on_expires_at"
  end

  create_table "ownerdocs", force: :cascade do |t|
    t.string "name"
    t.string "doc_type"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["owner_id"], name: "index_ownerdocs_on_owner_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "address_line"
    t.string "city"
    t.string "state"
    t.string "country"
    t.integer "pin_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_owners_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_properties_on_owner_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.binary "key", null: false
    t.binary "value", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_solid_cache_entries_on_created_at"
    t.index ["key"], name: "index_solid_cache_entries_on_key", unique: true
  end

  create_table "solid_queue_jobs", force: :cascade do |t|
    t.string "queue_name"
    t.text "arguments"
    t.string "class_name"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.string "status"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["queue_name"], name: "index_solid_queue_jobs_on_queue_name"
    t.index ["scheduled_at"], name: "index_solid_queue_jobs_on_scheduled_at"
    t.index ["status"], name: "index_solid_queue_jobs_on_status"
  end

  create_table "solid_queue_recurring_executions", force: :cascade do |t|
    t.string "task_key"
    t.datetime "last_execution_at"
    t.datetime "next_execution_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_key"], name: "index_solid_queue_recurring_executions_on_task_key", unique: true
  end

  create_table "tenantdocs", force: :cascade do |t|
    t.string "name"
    t.string "doc_type"
    t.bigint "tenant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tenant_id"], name: "index_tenantdocs_on_tenant_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "street_address"
    t.string "street_address_2"
    t.string "city"
    t.string "region"
    t.string "postal_code"
    t.string "country"
    t.string "email"
    t.string "phone"
    t.date "check_in"
    t.date "check_out"
    t.integer "adults"
    t.integer "children"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bookings", "properties"
  add_foreign_key "bookings", "users", column: "tenant_id"
  add_foreign_key "ownerdocs", "owners"
  add_foreign_key "owners", "users"
  add_foreign_key "properties", "owners"
  add_foreign_key "tenantdocs", "tenants"
end
