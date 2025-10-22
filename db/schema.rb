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

ActiveRecord::Schema[8.1].define(version: 2025_10_22_211833) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "media_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "media_type"
    t.text "overview"
    t.string "poster_path"
    t.date "release_date"
    t.string "title"
    t.integer "tmdb_id"
    t.datetime "updated_at", null: false
    t.index ["tmdb_id"], name: "index_media_items_on_tmdb_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "stripe_customer_id"
    t.string "subscription_status"
    t.string "tmdb_api_key"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "watchlist_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "media_item_id", null: false
    t.string "status", default: "planned", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.date "watched_on"
    t.index ["media_item_id"], name: "index_watchlist_items_on_media_item_id"
    t.index ["user_id", "media_item_id"], name: "index_watchlist_items_on_user_id_and_media_item_id", unique: true
    t.index ["user_id"], name: "index_watchlist_items_on_user_id"
  end

  add_foreign_key "watchlist_items", "media_items"
  add_foreign_key "watchlist_items", "users"
end
