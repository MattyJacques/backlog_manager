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

ActiveRecord::Schema[7.1].define(version: 2024_08_29_163211) do
  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "game_statuses", force: :cascade do |t|
    t.integer "status", null: false
    t.integer "game_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_statuses_on_game_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "igdb_id"
    t.index ["igdb_id"], name: "unique game igdb_id", unique: true
  end

  create_table "games_genres", id: false, force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "genre_id", null: false
    t.index ["game_id", "genre_id"], name: "index_games_genres_on_game_id_and_genre_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "igdb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique genre igdb_id", unique: true
    t.index ["name"], name: "unique genre name", unique: true
    t.index ["slug"], name: "unique genre slug", unique: true
  end

  create_table "platform_families", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.integer "igdb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique platform_family igdb_id", unique: true
    t.index ["name"], name: "unique platform_family name", unique: true
    t.index ["slug"], name: "unique platform_family slug", unique: true
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name"
    t.string "abbreviation"
    t.string "slug"
    t.integer "igdb_id", null: false
    t.integer "platform_family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique platform igdb_id", unique: true
    t.index ["name"], name: "unique platform name", unique: true
    t.index ["platform_family_id"], name: "index_platforms_on_platform_family_id"
    t.index ["slug"], name: "unique platform slug", unique: true
  end

  create_table "releases", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "platform_id", null: false
    t.integer "region"
    t.date "date"
    t.integer "igdb_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_releases_on_game_id"
    t.index ["igdb_id"], name: "unique release igdb_id", unique: true
    t.index ["platform_id"], name: "index_releases_on_platform_id"
  end

  add_foreign_key "game_statuses", "games"
  add_foreign_key "platforms", "platform_families"
  add_foreign_key "releases", "games"
  add_foreign_key "releases", "platforms"
end
