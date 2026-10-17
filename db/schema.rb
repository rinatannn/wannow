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

ActiveRecord::Schema[8.0].define(version: 2026_10_17_045730) do
  create_table "check_ins", force: :cascade do |t|
    t.integer "dog_id", null: false
    t.integer "dog_run_id", null: false
    t.datetime "checked_in_at", null: false
    t.datetime "checked_out_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_check_ins_on_dog_id"
    t.index ["dog_run_id"], name: "index_check_ins_on_dog_run_id"
  end

  create_table "dog_runs", force: :cascade do |t|
    t.string "name", null: false
    t.string "address", null: false
    t.time "opening_time", null: false
    t.time "closing_time", null: false
    t.boolean "indoor", default: false, null: false
    t.decimal "latitude", null: false
    t.decimal "longitude", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dogs", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "name", null: false
    t.string "breed", null: false
    t.string "personality", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dogs_on_user_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["user_id", "group_id"], name: "index_group_memberships_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_group_memberships_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "posts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "title", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_posts_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "admin", default: false, null: false
    t.boolean "is_active", default: true, null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "visit_plans", force: :cascade do |t|
    t.integer "dog_id", null: false
    t.integer "dog_run_id", null: false
    t.datetime "planned_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dog_id"], name: "index_visit_plans_on_dog_id"
    t.index ["dog_run_id"], name: "index_visit_plans_on_dog_run_id"
  end

  add_foreign_key "check_ins", "dog_runs"
  add_foreign_key "check_ins", "dogs"
  add_foreign_key "dogs", "users"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users"
  add_foreign_key "posts", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "visit_plans", "dog_runs"
  add_foreign_key "visit_plans", "dogs"
end
