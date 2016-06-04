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

ActiveRecord::Schema.define(version: 20160603080041) do

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
    t.decimal  "price",                          precision: 8, scale: 2
    t.string   "image_file_name",    limit: 255
    t.string   "image_content_type", limit: 255
    t.integer  "image_file_size",    limit: 4
    t.datetime "image_updated_at"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
  end

  add_index "meals", ["name"], name: "index_meals_on_name", using: :btree

  create_table "recipe_items", force: :cascade do |t|
    t.integer  "ingredient_id", limit: 4
    t.integer  "meal_id",       limit: 4
    t.decimal  "quantity",                precision: 10
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
  end

  add_index "recipe_items", ["ingredient_id"], name: "index_recipe_items_on_ingredient_id", using: :btree
  add_index "recipe_items", ["meal_id"], name: "index_recipe_items_on_meal_id", using: :btree

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
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["forgot_password_token"], name: "index_users_on_forgot_password_token", using: :btree
  add_index "users", ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
  add_index "users", ["verification_token"], name: "index_users_on_verification_token", using: :btree

  add_foreign_key "inventory_items", "ingredients"
  add_foreign_key "inventory_items", "locations"
  add_foreign_key "recipe_items", "ingredients"
  add_foreign_key "recipe_items", "meals"
end
