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

ActiveRecord::Schema.define(version: 20170727193412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", id: :serial, force: :cascade do |t|
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.integer "organizer_id", null: false
    t.string "name", null: false
    t.datetime "starts_at", null: false
    t.datetime "ends_at", null: false
    t.boolean "is_public", null: false
    t.integer "min_team_size", null: false
    t.integer "max_team_size", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "zip_file_file_name"
    t.string "zip_file_content_type"
    t.integer "zip_file_file_size"
    t.datetime "zip_file_updated_at"
    t.index ["is_public", "starts_at"], name: "index_games_on_is_public_and_starts_at"
    t.index ["organizer_id"], name: "index_games_on_organizer_id"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.string "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "game_id", null: false
    t.integer "user_id", null: false
    t.boolean "is_admin", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["game_id", "user_id"], name: "index_memberships_on_game_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "missions", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.string "description"
    t.integer "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
    t.string "avatar_file_name"
    t.string "avatar_content_type"
    t.integer "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer "codenum", default: 0, null: false
    t.string "normalized_name"
    t.index ["game_id", "codenum"], name: "index_missions_on_game_id_and_codenum"
    t.index ["game_id", "normalized_name"], name: "index_missions_on_game_id_and_normalized_name"
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.integer "mission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "bonus_points"
    t.string "notes"
    t.boolean "rejected", default: false, null: false
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.integer "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "submitted_at"
    t.integer "team_id"
    t.integer "width"
    t.integer "height"
    t.index ["game_id", "created_at"], name: "index_photos_on_game_id_and_created_at"
    t.index ["game_id", "rejected"], name: "index_photos_on_game_id_and_rejected"
    t.index ["mission_id"], name: "index_photos_on_mission_id"
    t.index ["team_id", "rejected"], name: "index_photos_on_team_id_and_rejected"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "normalized_name", null: false
    t.index ["game_id", "name"], name: "index_teams_on_game_id_and_name"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
