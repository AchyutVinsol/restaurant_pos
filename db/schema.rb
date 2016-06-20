# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160617080559) do

  create_table "extra_items", force: :cascade do |t|
    t.integer  "line_item_id",  limit: 4
    t.integer  "ingredient_id", limit: 4
    t.decimal  "price",                   precision: 8, scale: 2
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "extra_items", ["ingredient_id"], name: "index_extra_items_on_ingredient_id", using: :btree
  add_index "extra_items", ["line_item_id"], name: "index_extra_items_on_line_item_id", using: :btree

  create_table "ingredients", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.decimal  "price",                         precision: 8, scale: 2
    t.boolean  "veg",                                                   default: true
    t.boolean  "can_request_extra",                                     default: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "ingredients", ["name"], name: "index_ingredients_on_name", using: :btree

  create_table "inventory_items", force: :cascade do |t|
    t.integer  "location_id",   limit: 4
    t.integer  "ingredient_id", limit: 4
    t.decimal  "quantity",                precision: 10
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "inventory_items", ["ingredient_id"], name: "index_inventory_items_on_ingredient_id", using: :btree
  add_index "inventory_items", ["location_id"], name: "index_inventory_items_on_location_id", using: :btree

  create_table "line_items", force: :cascade do |t|
    t.decimal  "price",                precision: 8,  scale: 2
    t.integer  "meal_id",    limit: 4
    t.integer  "order_id",   limit: 4
    t.decimal  "quantity",             precision: 10
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "line_items", ["meal_id"], name: "index_line_items_on_meal_id", using: :btree
  add_index "line_items", ["order_id"], name: "index_line_items_on_order_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "state",            limit: 255
    t.string   "city",             limit: 255
    t.string   "street_first",     limit: 255
    t.string   "street_second",    limit: 255
    t.boolean  "default_location",             default: false
    t.datetime "opening_time"
    t.datetime "closing_time"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "locations", ["name"], name: "index_locations_on_name", using: :btree

  create_table "meals", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.decimal  "price",                            precision: 8, scale: 2
    t.boolean  "active",                                                   default: true
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.text     "description",        limit: 65535
  end

  add_index "meals", ["name"], name: "index_meals_on_name", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id",        limit: 4
    t.integer  "location_id",    limit: 4
    t.datetime "expiry_at"
    t.datetime "placed_at"
    t.datetime "pickup_time"
    t.integer  "status",         limit: 4,                           default: 0
    t.string   "contact_number", limit: 255,                         default: "99999"
    t.decimal  "price",                      precision: 8, scale: 2
    t.datetime "created_at",                                                           null: false
    t.datetime "updated_at",                                                           null: false
  end

  add_index "orders", ["location_id"], name: "index_orders_on_location_id", using: :btree
  add_index "orders", ["user_id"], name: "index_orders_on_user_id", using: :btree

  create_table "recipe_items", force: :cascade do |t|
    t.integer  "ingredient_id", limit: 4
    t.integer  "meal_id",       limit: 4
    t.decimal  "quantity",                precision: 10
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "recipe_items", ["ingredient_id"], name: "index_recipe_items_on_ingredient_id", using: :btree
  add_index "recipe_items", ["meal_id"], name: "index_recipe_items_on_meal_id", using: :btree

  create_table "transactions", force: :cascade do |t|
    t.boolean  "captured",                                        default: true
    t.decimal  "amount",                  precision: 8, scale: 2
    t.integer  "order_id",    limit: 4
    t.string   "last4",       limit: 255,                         default: "xxxx"
    t.string   "brand",       limit: 255,                         default: "Fake"
    t.string   "currency",    limit: 255,                         default: "usd"
    t.string   "card_id",     limit: 255
    t.string   "charge_id",   limit: 255
    t.string   "customer_id", limit: 255
    t.datetime "created_at",                                                       null: false
    t.datetime "updated_at",                                                       null: false
  end

  add_index "transactions", ["card_id"], name: "index_transactions_on_card_id", using: :btree
  add_index "transactions", ["charge_id"], name: "index_transactions_on_charge_id", using: :btree
  add_index "transactions", ["customer_id"], name: "index_transactions_on_customer_id", using: :btree
  add_index "transactions", ["order_id"], name: "index_transactions_on_order_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",                      limit: 255
    t.string   "last_name",                       limit: 255
    t.string   "email",                           limit: 255
    t.string   "password_digest",                 limit: 255
    t.boolean  "admin",                                       default: false
    t.datetime "verified_at"
    t.string   "verification_token",              limit: 255
    t.datetime "verification_token_expiry_at"
    t.string   "forgot_password_token",           limit: 255
    t.datetime "forgot_password_token_expiry_at"
    t.string   "remember_me_token",               limit: 255
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "prefered_location_id",            limit: 4
    t.string   "stripe_user_id",                  limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["forgot_password_token"], name: "index_users_on_forgot_password_token", using: :btree
  add_index "users", ["prefered_location_id"], name: "index_users_on_prefered_location_id", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["verification_token"], name: "index_users_on_verification_token", using: :btree

  add_foreign_key "extra_items", "ingredients"
  add_foreign_key "extra_items", "line_items"
  add_foreign_key "inventory_items", "ingredients"
  add_foreign_key "inventory_items", "locations"
  add_foreign_key "line_items", "meals"
  add_foreign_key "line_items", "orders"
  add_foreign_key "orders", "locations"
  add_foreign_key "orders", "users"
  add_foreign_key "recipe_items", "ingredients"
  add_foreign_key "recipe_items", "meals"
  add_foreign_key "transactions", "orders"
end
