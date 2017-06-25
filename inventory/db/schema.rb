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

ActiveRecord::Schema.define(version: 20170625140315) do

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
    t.index ["container_id"], name: "index_items_on_container_id"
    t.index ["serial"], name: "index_items_on_serial", unique: true
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "table_movements", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "user_id"
    t.bigint "item_id"
    t.bigint "container_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id"], name: "index_table_movements_on_container_id"
    t.index ["item_id"], name: "index_table_movements_on_item_id"
    t.index ["user_id"], name: "index_table_movements_on_user_id"
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "can_edit"
    t.boolean "can_add"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "items", "items", column: "container_id"
  add_foreign_key "items", "users"
end
