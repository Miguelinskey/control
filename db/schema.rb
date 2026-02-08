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

ActiveRecord::Schema[8.1].define(version: 2026_02_08_091444) do
  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.string "slug", null: false
    t.integer "topics_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "topic_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["topic_id"], name: "index_posts_on_topic_id"
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.text "body", null: false
    t.integer "category_id", null: false
    t.datetime "created_at", null: false
    t.boolean "locked", default: false, null: false
    t.boolean "pinned", default: false, null: false
    t.integer "posts_count", default: 0, null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["category_id"], name: "index_topics_on_category_id"
    t.index ["user_id"], name: "index_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "banned", default: false, null: false
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "member", null: false
    t.string "signup_ip"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "posts", "topics"
  add_foreign_key "posts", "users"
  add_foreign_key "topics", "categories"
  add_foreign_key "topics", "users"
end
