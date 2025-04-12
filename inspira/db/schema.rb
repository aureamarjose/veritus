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

ActiveRecord::Schema[7.1].define(version: 2024_11_21_211547) do
  create_table "additional_charges", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "lauch_date"
    t.string "release_description"
    t.string "lauch_value"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cash_flow_id"
    t.index ["cash_flow_id"], name: "index_additional_charges_on_cash_flow_id"
    t.index ["service_id"], name: "index_additional_charges_on_service_id"
  end

  create_table "addresses", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "neighborhood"
    t.string "street"
    t.string "city"
    t.string "cep"
    t.string "uf"
    t.string "complement"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "add_number"
    t.boolean "deleted"
    t.index ["client_id"], name: "index_addresses_on_client_id"
  end

  create_table "admins", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bills_to_pays", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "description"
    t.date "expiration_date"
    t.string "value"
    t.boolean "status"
    t.date "pay_day"
    t.boolean "deleted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.bigint "cash_flow_id"
    t.index ["cash_flow_id"], name: "index_bills_to_pays_on_cash_flow_id"
    t.index ["category_id"], name: "index_bills_to_pays_on_category_id"
  end

  create_table "cash_flows", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "lauch_date"
    t.string "lauch_description"
    t.string "lauch_type"
    t.string "lauch_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "balance"
    t.string "source_model"
  end

  create_table "cash_registers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories_accounts_payables", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "type_account_id"
    t.index ["type_account_id"], name: "index_categories_accounts_payables_on_type_account_id"
  end

  create_table "clients", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name_client"
    t.string "legal_situation"
    t.string "number_doc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted"
  end

  create_table "emails", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_emails_on_client_id"
  end

  create_table "execution_services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "service_date"
    t.integer "amount"
    t.string "value"
    t.string "total"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "list_service_id"
    t.index ["list_service_id"], name: "index_execution_services_on_list_service_id"
    t.index ["service_id"], name: "index_execution_services_on_service_id"
  end

  create_table "list_services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "service_name"
    t.boolean "list_delete"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "operational_costs", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "lauch_date"
    t.string "release_description"
    t.string "lauch_value"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cash_flow_id"
    t.bigint "list_service_id"
    t.index ["cash_flow_id"], name: "index_operational_costs_on_cash_flow_id"
    t.index ["list_service_id"], name: "index_operational_costs_on_list_service_id"
    t.index ["service_id"], name: "index_operational_costs_on_service_id"
  end

  create_table "phones", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "phone"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_phones_on_client_id"
  end

  create_table "receiveds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.date "lauch_date"
    t.string "release_description"
    t.string "lauch_value"
    t.bigint "service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cash_flow_id"
    t.index ["cash_flow_id"], name: "index_receiveds_on_cash_flow_id"
    t.index ["service_id"], name: "index_receiveds_on_service_id"
  end

  create_table "services", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "folder"
    t.string "sector"
    t.date "start_date"
    t.date "end_date"
    t.string "financial_situation"
    t.string "progress"
    t.string "description"
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "exc_client2_id"
    t.bigint "address_id"
    t.index ["address_id"], name: "index_services_on_address_id"
    t.index ["client_id"], name: "index_services_on_client_id"
    t.index ["exc_client2_id"], name: "index_services_on_exc_client2_id"
  end

  create_table "type_of_accounts", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name_account"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "additional_charges", "cash_flows"
  add_foreign_key "additional_charges", "services"
  add_foreign_key "addresses", "clients"
  add_foreign_key "bills_to_pays", "cash_flows"
  add_foreign_key "bills_to_pays", "categories_accounts_payables", column: "category_id"
  add_foreign_key "categories_accounts_payables", "type_of_accounts", column: "type_account_id"
  add_foreign_key "emails", "clients"
  add_foreign_key "execution_services", "list_services"
  add_foreign_key "execution_services", "services"
  add_foreign_key "operational_costs", "cash_flows"
  add_foreign_key "operational_costs", "list_services"
  add_foreign_key "operational_costs", "services"
  add_foreign_key "phones", "clients"
  add_foreign_key "receiveds", "cash_flows"
  add_foreign_key "receiveds", "services"
  add_foreign_key "services", "addresses"
  add_foreign_key "services", "clients"
  add_foreign_key "services", "clients", column: "exc_client2_id"
end
