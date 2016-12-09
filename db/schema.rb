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

ActiveRecord::Schema.define(version: 20160624060218) do

  create_table "extra_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "line_item_id"
    t.integer  "ingredient_id"
    t.decimal  "price",         precision: 8, scale: 2
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["ingredient_id"], name: "index_extra_items_on_ingredient_id", using: :btree
    t.index ["line_item_id"], name: "index_extra_items_on_line_item_id", using: :btree
  end

  create_table "ingredients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.decimal  "price",             precision: 8, scale: 2
    t.boolean  "veg",                                       default: true
    t.boolean  "can_request_extra",                         default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["name"], name: "index_ingredients_on_name", using: :btree
  end

  create_table "inventory_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "location_id"
    t.integer  "ingredient_id"
    t.decimal  "quantity",      precision: 10
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["ingredient_id"], name: "index_inventory_items_on_ingredient_id", using: :btree
    t.index ["location_id"], name: "index_inventory_items_on_location_id", using: :btree
  end

  create_table "line_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.decimal  "price",      precision: 8,  scale: 2
    t.integer  "meal_id"
    t.integer  "order_id"
    t.decimal  "quantity",   precision: 10
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["meal_id"], name: "index_line_items_on_meal_id", using: :btree
    t.index ["order_id"], name: "index_line_items_on_order_id", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "state"
    t.string   "city"
    t.string   "street_first"
    t.string   "street_second"
    t.boolean  "default_location", default: false
    t.datetime "opening_time"
    t.datetime "closing_time"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.index ["name"], name: "index_locations_on_name", using: :btree
  end

  create_table "meals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.decimal  "price",                            precision: 8, scale: 2
    t.boolean  "active",                                                   default: true
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.text     "description",        limit: 65535
    t.index ["name"], name: "index_meals_on_name", using: :btree
  end

  create_table "orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "location_id"
    t.datetime "expiry_at"
    t.datetime "placed_at"
    t.datetime "pickup_time"
    t.integer  "status",                                 default: 0
    t.string   "contact_number",                         default: "99999"
    t.decimal  "price",          precision: 8, scale: 2
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.index ["location_id"], name: "index_orders_on_location_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "recipe_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "ingredient_id"
    t.integer  "meal_id"
    t.decimal  "quantity",      precision: 10
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["ingredient_id"], name: "index_recipe_items_on_ingredient_id", using: :btree
    t.index ["meal_id"], name: "index_recipe_items_on_meal_id", using: :btree
  end

  create_table "reviews", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "comment"
    t.integer  "rating"
    t.integer  "user_id"
    t.string   "reviewable_type"
    t.integer  "reviewable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["reviewable_type", "reviewable_id"], name: "index_reviews_on_reviewable_type_and_reviewable_id", using: :btree
    t.index ["user_id"], name: "index_reviews_on_user_id", using: :btree
  end

  create_table "transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.boolean  "captured",                            default: true
    t.decimal  "amount",      precision: 8, scale: 2
    t.integer  "order_id"
    t.string   "last4",                               default: "xxxx"
    t.string   "brand",                               default: "Fake"
    t.string   "currency",                            default: "usd"
    t.string   "card_id"
    t.string   "charge_id"
    t.string   "customer_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.index ["card_id"], name: "index_transactions_on_card_id", using: :btree
    t.index ["charge_id"], name: "index_transactions_on_charge_id", using: :btree
    t.index ["customer_id"], name: "index_transactions_on_customer_id", using: :btree
    t.index ["order_id"], name: "index_transactions_on_order_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",                           default: false
    t.datetime "verified_at"
    t.string   "verification_token"
    t.datetime "verification_token_expiry_at"
    t.string   "forgot_password_token"
    t.datetime "forgot_password_token_expiry_at"
    t.string   "remember_me_token"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "prefered_location_id"
    t.string   "stripe_user_id"
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["forgot_password_token"], name: "index_users_on_forgot_password_token", using: :btree
    t.index ["prefered_location_id"], name: "index_users_on_prefered_location_id", using: :btree
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token", using: :btree
    t.index ["verification_token"], name: "index_users_on_verification_token", using: :btree
  end

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
