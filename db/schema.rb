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

ActiveRecord::Schema[8.0].define(version: 2025_09_01_003354) do
  create_table "categories", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "category_id"
    t.integer "location_id"
    t.string "name", null: false
    t.text "note"
    t.integer "purchase_value_cents", default: 0, null: false
    t.string "purchase_value_currency", default: "USD", null: false
    t.integer "current_value_cents", default: 0, null: false
    t.string "current_value_currency", default: "USD", null: false
    t.date "acquired_on"
    t.date "discarded_on"
    t.date "last_seen_on"
    t.integer "expected_uses", default: 30, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "last_used_on"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["location_id"], name: "index_items_on_location_id"
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.boolean "storage", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_locations_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "usages", force: :cascade do |t|
    t.integer "item_id", null: false
    t.date "used_on", null: false
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_usages_on_item_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "items", "categories"
  add_foreign_key "items", "locations"
  add_foreign_key "items", "users"
  add_foreign_key "locations", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "usages", "items"
end
