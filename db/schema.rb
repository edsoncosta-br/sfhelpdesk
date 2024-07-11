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

ActiveRecord::Schema.define(version: 2024_07_11_193840) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

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

  create_table "requests", force: :cascade do |t|
    t.string "title", limit: 100, null: false
    t.datetime "created_date", null: false
    t.integer "step", null: false
    t.integer "priority", null: false
    t.integer "status"
    t.string "requester_name", limit: 30
    t.integer "customer_id"
    t.integer "project_id", null: false
    t.integer "user_created_id", null: false
    t.integer "user_status_id"
    t.integer "mark_id"
    t.integer "topic_id", null: false
    t.integer "sub_topic_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sub_topics", force: :cascade do |t|
    t.string "description", limit: 30, null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id", "description"], name: "index_sub_topics_on_topic_id_and_description", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "description", limit: 30, null: false
    t.string "color", limit: 7
    t.bigint "project_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id", "description"], name: "index_topics_on_project_id_and_description", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 60, default: "", null: false
    t.string "name", limit: 60, default: "", null: false
    t.string "nick_name", limit: 20, default: ""
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

  add_foreign_key "allocations", "projects", on_delete: :cascade
  add_foreign_key "allocations", "users", on_delete: :cascade
  add_foreign_key "customers", "cities"
  add_foreign_key "customers", "companies"
  add_foreign_key "marks", "projects"
  add_foreign_key "positions", "companies"
  add_foreign_key "projects", "companies"
  add_foreign_key "requests", "customers"
  add_foreign_key "requests", "marks"
  add_foreign_key "requests", "projects"
  add_foreign_key "requests", "sub_topics"
  add_foreign_key "requests", "topics"
  add_foreign_key "requests", "users", column: "user_created_id"
  add_foreign_key "requests", "users", column: "user_status_id"
  add_foreign_key "sub_topics", "topics", on_delete: :cascade
  add_foreign_key "topics", "projects"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "positions"
end
