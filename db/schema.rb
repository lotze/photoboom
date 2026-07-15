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

ActiveRecord::Schema[8.1].define(version: 2026_07_15_032332) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "authorizations", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.string "provider"
    t.string "uid"
    t.datetime "updated_at"
    t.integer "user_id"
    t.index ["provider", "uid"], name: "index_authorizations_on_provider_and_uid"
    t.index ["user_id"], name: "index_authorizations_on_user_id"
  end

  create_table "games", id: :serial, force: :cascade do |t|
    t.string "contact"
    t.datetime "created_at"
    t.string "end_location"
    t.datetime "ends_at", null: false
    t.boolean "is_public", null: false
    t.datetime "launched_at"
    t.integer "max_team_size", null: false
    t.integer "min_team_size", null: false
    t.string "name", null: false
    t.integer "organizer_id", null: false
    t.string "start_location"
    t.datetime "starts_at", null: false
    t.string "stripe_checkout_session_id"
    t.string "tier", default: "free", null: false
    t.string "timezone"
    t.datetime "updated_at"
    t.index ["is_public", "starts_at"], name: "index_games_on_is_public_and_starts_at"
    t.index ["organizer_id"], name: "index_games_on_organizer_id"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.string "email"
    t.string "password_digest"
    t.datetime "updated_at"
    t.index ["email"], name: "index_identities_on_email"
  end

  create_table "missions", id: :serial, force: :cascade do |t|
    t.integer "codenum", default: 0, null: false
    t.datetime "created_at"
    t.string "description"
    t.integer "game_id"
    t.string "name"
    t.string "normalized_name"
    t.integer "points"
    t.datetime "updated_at"
    t.index ["game_id", "codenum"], name: "index_missions_on_game_id_and_codenum"
    t.index ["game_id", "normalized_name"], name: "index_missions_on_game_id_and_normalized_name"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.bigint "game_id", null: false
    t.string "status", default: "pending", null: false
    t.string "stripe_checkout_session_id"
    t.string "stripe_payment_intent_id"
    t.string "tier", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_payments_on_game_id"
    t.index ["stripe_checkout_session_id"], name: "index_payments_on_stripe_checkout_session_id", unique: true
  end

  create_table "photos", id: :serial, force: :cascade do |t|
    t.integer "bonus_points"
    t.datetime "created_at"
    t.integer "game_id"
    t.integer "height"
    t.integer "mission_id"
    t.string "notes"
    t.boolean "rejected", default: false, null: false
    t.boolean "reviewed", default: false, null: false
    t.datetime "submitted_at"
    t.integer "team_id"
    t.datetime "updated_at"
    t.integer "user_id"
    t.integer "width"
    t.index ["game_id", "created_at"], name: "index_photos_on_game_id_and_created_at"
    t.index ["game_id", "rejected"], name: "index_photos_on_game_id_and_rejected"
    t.index ["mission_id"], name: "index_photos_on_mission_id"
    t.index ["team_id", "rejected"], name: "index_photos_on_team_id_and_rejected"
  end

  create_table "registrations", id: :serial, force: :cascade do |t|
    t.boolean "agree_photo"
    t.boolean "agree_waiver"
    t.datetime "created_at"
    t.integer "game_id", null: false
    t.boolean "is_admin", null: false
    t.string "legal_name"
    t.string "payment_token"
    t.integer "team_id"
    t.datetime "updated_at"
    t.integer "user_id", null: false
    t.index ["game_id", "user_id"], name: "index_registrations_on_game_id_and_user_id", unique: true
    t.index ["team_id"], name: "index_registrations_on_team_id"
    t.index ["user_id"], name: "index_registrations_on_user_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.datetime "created_at"
    t.integer "game_id"
    t.string "name"
    t.string "normalized_name", null: false
    t.datetime "updated_at"
    t.index ["game_id", "name"], name: "index_teams_on_game_id_and_name"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at"
    t.string "email"
    t.string "name"
    t.datetime "updated_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payments", "games"
end
