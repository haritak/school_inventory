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

ActiveRecord::Schema.define(version: 20170908023900) do

  create_table "item_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "category", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_item_categories_on_category", unique: true
  end

  create_table "item_edits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "item_id"
    t.string "field_name"
    t.binary "old_value", limit: 16777215
    t.binary "new_value", limit: 16777215
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_edits_on_item_id"
    t.index ["user_id"], name: "index_item_edits_on_user_id"
  end

  create_table "item_movements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "item_id"
    t.bigint "container_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id"], name: "index_item_movements_on_container_id"
    t.index ["item_id"], name: "index_item_movements_on_item_id"
    t.index ["user_id"], name: "index_item_movements_on_user_id"
  end

  create_table "item_photos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "item_id"
    t.string "filename"
    t.integer "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "type"
    t.index ["item_id"], name: "index_item_photos_on_item_id"
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "serial", null: false
    t.string "description"
    t.string "page_url"
    t.binary "photo_data", limit: 16777215
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "photo_data2", limit: 16777215
    t.binary "invoice", limit: 16777215
    t.bigint "container_id"
    t.bigint "user_id"
    t.integer "quantity", default: 1
    t.text "note"
    t.bigint "item_category_id"
    t.boolean "burned", default: false
    t.index ["container_id"], name: "index_items_on_container_id"
    t.index ["item_category_id"], name: "index_items_on_item_category_id"
    t.index ["serial"], name: "index_items_on_serial", unique: true
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_edit"
    t.boolean "can_add"
    t.boolean "is_admin", default: false
    t.string "rooms"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "item_edits", "items"
  add_foreign_key "item_edits", "users"
  add_foreign_key "item_photos", "items"
  add_foreign_key "items", "item_categories"
  add_foreign_key "items", "items", column: "container_id"
  add_foreign_key "items", "users"
end
