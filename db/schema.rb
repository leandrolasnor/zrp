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

ActiveRecord::Schema[8.0].define(version: 2023_10_02_064944) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "battles", force: :cascade do |t|
    t.integer "score"
    t.integer "hero_id", null: false
    t.integer "threat_id", null: false
    t.datetime "finished_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["score"], name: "index_battles_on_score"
  end

  create_table "heroes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "rank", null: false
    t.integer "status", default: 1, null: false
    t.decimal "lat", precision: 18, scale: 15
    t.decimal "lng", precision: 18, scale: 15
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_heroes_on_deleted_at"
  end

  create_table "threats", force: :cascade do |t|
    t.string "name"
    t.integer "rank"
    t.integer "status", default: 1
    t.decimal "lat", precision: 18, scale: 15
    t.decimal "lng", precision: 18, scale: 15
    t.text "payload", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "battles", "heroes"
  add_foreign_key "battles", "threats"
end
