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

ActiveRecord::Schema.define(version: 20171113213640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "credit_cards", force: :cascade do |t|
    t.bigint "wallet_id"
    t.decimal "limit", precision: 12, scale: 2, default: "0.0", null: false
    t.decimal "balance", precision: 12, scale: 2, default: "0.0", null: false
    t.date "payment_due_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number", null: false
    t.string "card_holder", null: false
    t.integer "cvv", null: false
    t.date "expiration_date"
    t.decimal "remaining_limit", precision: 12, scale: 2, default: "0.0", null: false
    t.index ["wallet_id"], name: "index_credit_cards_on_wallet_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "auth_token", default: ""
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "wallets", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "limit", precision: 12, scale: 2, default: "0.0", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id"
  end

end
