# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130817202057) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authorizations", force: true do |t|
    t.string   "provider"
    t.string   "uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["provider", "uid"], name: "index_authorizations_on_provider_and_uid", using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "games", force: true do |t|
    t.integer  "organizer_id",   null: false
    t.string   "name",           null: false
    t.datetime "starts_at",      null: false
    t.datetime "ends_at",        null: false
    t.datetime "voting_ends_at", null: false
    t.integer  "cost",           null: false
    t.string   "currency",       null: false
    t.boolean  "is_public",      null: false
    t.integer  "min_team_size",  null: false
    t.integer  "max_team_size",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["is_public", "starts_at"], name: "index_games_on_is_public_and_starts_at", using: :btree
  add_index "games", ["organizer_id"], name: "index_games_on_organizer_id", using: :btree

  create_table "identities", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identities", ["email"], name: "index_identities_on_email", using: :btree

  create_table "memberships", force: true do |t|
    t.integer  "team_id",    null: false
    t.integer  "game_id",    null: false
    t.integer  "user_id",    null: false
    t.boolean  "is_admin",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["game_id", "user_id"], name: "index_memberships_on_game_id_and_user_id", using: :btree
  add_index "memberships", ["team_id"], name: "index_memberships_on_team_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "missions", force: true do |t|
    t.integer  "game_id"
    t.string   "description"
    t.integer  "points"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "missions", ["game_id"], name: "index_missions_on_game_id", using: :btree

  create_table "photos", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "mission_id"
    t.string   "resource_location"
    t.float    "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["game_id", "rating"], name: "index_photos_on_game_id_and_rating", using: :btree
  add_index "photos", ["mission_id", "rating"], name: "index_photos_on_mission_id_and_rating", using: :btree
  add_index "photos", ["user_id", "rating"], name: "index_photos_on_user_id_and_rating", using: :btree

  create_table "teams", force: true do |t|
    t.integer  "game_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["game_id", "name"], name: "index_teams_on_game_id_and_name", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
