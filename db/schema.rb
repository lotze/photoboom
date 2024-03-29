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

ActiveRecord::Schema[7.0].define(version: 2017_08_29_012138) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", id: :serial, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
    t.index ["user_id"], name: "index_authorizations_on_user_id"
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
    t.string "timezone"
    t.string "start_location"
    t.string "contact"
    t.string "end_location"
    t.index ["is_public", "starts_at"], name: "index_games_on_is_public_and_starts_at"
    t.index ["organizer_id"], name: "index_games_on_organizer_id"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["email"], name: "index_identities_on_email"
  end

  create_table "missions", id: :serial, force: :cascade do |t|
    t.integer "game_id"
    t.string "description"
    t.integer "points"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name"
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
    t.boolean "reviewed", default: false, null: false
    t.index ["game_id", "created_at"], name: "index_photos_on_game_id_and_created_at"
    t.index ["game_id", "rejected"], name: "index_photos_on_game_id_and_rejected"
    t.index ["mission_id"], name: "index_photos_on_mission_id"
    t.index ["team_id", "rejected"], name: "index_photos_on_team_id_and_rejected"
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "game_id", null: false
    t.integer "user_id", null: false
    t.boolean "is_admin", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "payment_token"
    t.string "legal_name"
    t.boolean "agree_waiver"
    t.boolean "agree_photo"
    t.index ["game_id", "user_id"], name: "index_registrations_on_game_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_registrations_on_team_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
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
    t.string "name"
    t.string "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
