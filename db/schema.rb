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

ActiveRecord::Schema.define(version: 2024_10_04_161228) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", limit: 60, default: "", null: false
    t.string "name", limit: 60, default: "", null: false
    t.boolean "active", default: true
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "allocations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.boolean "main", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id", "user_id"], name: "index_allocations_on_project_id_and_user_id", unique: true
  end

  create_table "cities", force: :cascade do |t|
    t.string "name", limit: 50, default: "", null: false
    t.integer "ibge_code"
    t.string "state"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", limit: 60, null: false
    t.boolean "active", default: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "customers", force: :cascade do |t|
    t.integer "code", null: false
    t.string "name", limit: 100, default: "", null: false
    t.string "type_person", limit: 8
    t.string "cpfcnpj_number", limit: 18, null: false
    t.boolean "active", default: true
    t.string "address", limit: 50
    t.string "number", limit: 8
    t.string "complement", limit: 20
    t.string "district", limit: 30
    t.string "zip_code", limit: 9
    t.string "phone", limit: 15
    t.string "cellphone", limit: 15
    t.string "email", limit: 60
    t.boolean "code_typed", default: false
    t.bigint "city_id", null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code", "company_id"], name: "index_customers_on_code_and_company_id", unique: true
  end

  create_table "marks", force: :cascade do |t|
    t.string "description", limit: 30, null: false
    t.datetime "due_date"
    t.datetime "release_date"
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id", "description"], name: "index_marks_on_project_id_and_description", unique: true
  end

  create_table "positions", force: :cascade do |t|
    t.string "description", limit: 30, null: false
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["description"], name: "index_positions_on_description", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "description", limit: 60, null: false
    t.boolean "active", default: true
    t.bigint "company_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "request_comments", force: :cascade do |t|
    t.datetime "created_date", null: false
    t.bigint "user_id", null: false
    t.bigint "request_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "request_tags", force: :cascade do |t|
    t.bigint "request_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["request_id", "tag_id"], name: "index_request_tags_on_request_id_and_tag_id", unique: true
  end

  create_table "requests", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.datetime "created_date", null: false
    t.integer "status", null: false
    t.integer "step", null: false
    t.boolean "priority", default: false
    t.string "requester_name", limit: 30
    t.integer "customer_id"
    t.integer "project_id", null: false
    t.integer "user_created_id", null: false
    t.integer "user_responsible_id"
    t.integer "mark_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "due_date"
  end

  create_table "tags", force: :cascade do |t|
    t.string "description", limit: 30, null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id", "description"], name: "index_tags_on_project_id_and_description", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 60, default: "", null: false
    t.string "name", limit: 60, default: "", null: false
    t.string "nick_name", limit: 20, default: "", null: false
    t.boolean "active", default: true
    t.boolean "admin", default: false
    t.boolean "permission_admin_menu", default: false
    t.bigint "position_id"
    t.bigint "company_id", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "allocations", "projects", on_delete: :cascade
  add_foreign_key "allocations", "users", on_delete: :cascade
  add_foreign_key "customers", "cities"
  add_foreign_key "customers", "companies"
  add_foreign_key "marks", "projects"
  add_foreign_key "positions", "companies"
  add_foreign_key "projects", "companies"
  add_foreign_key "request_comments", "requests", on_delete: :cascade
  add_foreign_key "request_comments", "users"
  add_foreign_key "request_tags", "requests", on_delete: :cascade
  add_foreign_key "request_tags", "tags", on_delete: :cascade
  add_foreign_key "requests", "customers"
  add_foreign_key "requests", "marks"
  add_foreign_key "requests", "projects"
  add_foreign_key "requests", "users", column: "user_created_id"
  add_foreign_key "requests", "users", column: "user_responsible_id"
  add_foreign_key "tags", "projects"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "positions"
end
