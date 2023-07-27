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

ActiveRecord::Schema[7.0].define(version: 2023_07_20_132457) do
  create_table "account_trophy_lists", force: :cascade do |t|
    t.integer "psn_account_id", null: false
    t.integer "trophy_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psn_account_id", "trophy_list_id"], name: "unique join account trophy lists", unique: true
    t.index ["psn_account_id"], name: "index_account_trophy_lists_on_psn_account_id"
    t.index ["trophy_list_id"], name: "index_account_trophy_lists_on_trophy_list_id"
  end

  create_table "earned_trophies", force: :cascade do |t|
    t.integer "psn_account_id", null: false
    t.integer "trophy_id", null: false
    t.integer "trophy_list_id", null: false
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psn_account_id", "trophy_id"], name: "unique join account trophies", unique: true
    t.index ["psn_account_id"], name: "index_earned_trophies_on_psn_account_id"
    t.index ["trophy_id"], name: "index_earned_trophies_on_trophy_id"
    t.index ["trophy_list_id"], name: "index_earned_trophies_on_trophy_list_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id"
    t.integer "how_long_to_beat_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["how_long_to_beat_id"], name: "unique game HLTB ID index", unique: true
    t.index ["igdb_id"], name: "unique game IGDB ID index", unique: true
  end

  create_table "platform_families", force: :cascade do |t|
    t.string "name", null: false
    t.integer "igdb_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique family IGDB ID index", unique: true
    t.index ["name"], name: "unique family name index", unique: true
  end

  create_table "platforms", force: :cascade do |t|
    t.string "name", null: false
    t.string "abbreviation"
    t.integer "igdb_id"
    t.integer "platform_family_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["igdb_id"], name: "unique platform IGDB ID index", unique: true
    t.index ["name"], name: "unique platform name index", unique: true
    t.index ["platform_family_id"], name: "index_platforms_on_platform_family_id"
  end

  create_table "psn_accounts", force: :cascade do |t|
    t.string "psn_id"
    t.string "account_id"
    t.string "avatar"
    t.boolean "plus", default: false, null: false
    t.text "about_me"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["psn_id"], name: "unique PSN ID", unique: true
  end

  create_table "releases", force: :cascade do |t|
    t.integer "game_id", null: false
    t.integer "platform_id", null: false
    t.integer "region"
    t.date "date"
    t.integer "trophy_list_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "platform_id", "region"], name: "unique release index", unique: true
    t.index ["game_id"], name: "index_releases_on_game_id"
    t.index ["platform_id"], name: "index_releases_on_platform_id"
    t.index ["trophy_list_id"], name: "index_releases_on_trophy_list_id"
  end

  create_table "trophies", force: :cascade do |t|
    t.integer "trophy_list_id", null: false
    t.integer "psn_id", null: false
    t.string "name", null: false
    t.string "detail", null: false
    t.string "icon_url", null: false
    t.integer "rank", null: false
    t.boolean "hidden", default: false, null: false
    t.integer "progress_target", default: 1
    t.string "trophy_group"
    t.string "reward_name"
    t.string "reward_url"
    t.boolean "unobtainable", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trophy_list_id", "psn_id"], name: "unique trophy index", unique: true
    t.index ["trophy_list_id"], name: "index_trophies_on_trophy_list_id"
  end

  create_table "trophy_lists", force: :cascade do |t|
    t.string "name"
    t.string "detail"
    t.string "comm_id", null: false
    t.string "title_id"
    t.string "service", null: false
    t.integer "region"
    t.decimal "version"
    t.string "icon_url", null: false
    t.date "server_shutdown_date"
    t.string "psnp_id"
    t.string "psntl_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["comm_id"], name: "unique PSN communication ID index", unique: true
    t.index ["title_id"], name: "unique PSN title ID index", unique: true
  end

  add_foreign_key "account_trophy_lists", "psn_accounts"
  add_foreign_key "account_trophy_lists", "trophy_lists"
  add_foreign_key "earned_trophies", "psn_accounts"
  add_foreign_key "earned_trophies", "trophies"
  add_foreign_key "earned_trophies", "trophy_lists"
  add_foreign_key "platforms", "platform_families"
  add_foreign_key "releases", "games"
  add_foreign_key "releases", "platforms"
  add_foreign_key "releases", "trophy_lists"
  add_foreign_key "trophies", "trophy_lists"
end
