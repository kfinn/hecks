# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_08_040955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

# Could not dump table "adjacencies" because of following StandardError
#   Unknown type 'adjacency_corner_territory_relationship' for column 'corner_territory_relationship'

  create_table "borders", force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "corners", force: :cascade do |t|
    t.integer "x", null: false
    t.integer "y", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "discard_requirements", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "turn_id", null: false
    t.integer "resource_cards_count", null: false
    t.datetime "completed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["completed_at"], name: "index_discard_requirements_on_completed_at"
    t.index ["player_id"], name: "index_discard_requirements_on_player_id"
    t.index ["turn_id"], name: "index_discard_requirements_on_turn_id"
  end

  create_table "games", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "key", null: false
    t.datetime "started_at"
    t.bigint "current_turn_id"
    t.bigint "robber_territory_id", null: false
    t.index ["current_turn_id"], name: "index_games_on_current_turn_id"
    t.index ["robber_territory_id"], name: "index_games_on_robber_territory_id"
  end

  create_table "player_offers", force: :cascade do |t|
    t.bigint "turn_id", null: false
    t.integer "brick_cards_count_from_offering_player", null: false
    t.integer "grain_cards_count_from_offering_player", null: false
    t.integer "lumber_cards_count_from_offering_player", null: false
    t.integer "ore_cards_count_from_offering_player", null: false
    t.integer "wool_cards_count_from_offering_player", null: false
    t.integer "brick_cards_count_from_agreeing_player", null: false
    t.integer "grain_cards_count_from_agreeing_player", null: false
    t.integer "lumber_cards_count_from_agreeing_player", null: false
    t.integer "ore_cards_count_from_agreeing_player", null: false
    t.integer "wool_cards_count_from_agreeing_player", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["turn_id"], name: "index_player_offers_on_turn_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "ordering_roll_id"
    t.integer "ordering"
    t.integer "brick_cards_count", default: 0, null: false
    t.integer "grain_cards_count", default: 0, null: false
    t.integer "lumber_cards_count", default: 0, null: false
    t.integer "ore_cards_count", default: 0, null: false
    t.integer "wool_cards_count", default: 0, null: false
    t.string "color_id"
    t.index ["color_id", "game_id"], name: "index_players_on_color_id_and_game_id", unique: true
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["ordering"], name: "index_players_on_ordering"
    t.index ["ordering_roll_id"], name: "index_players_on_ordering_roll_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "roads", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "border_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["border_id"], name: "index_roads_on_border_id", unique: true
    t.index ["player_id"], name: "index_roads_on_player_id"
  end

  create_table "rolls", force: :cascade do |t|
    t.integer "die_1_value"
    t.integer "die_2_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "settlements", force: :cascade do |t|
    t.bigint "player_id"
    t.bigint "corner_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "upgraded_to_city_at"
    t.index ["corner_id"], name: "index_settlements_on_corner_id", unique: true
    t.index ["player_id"], name: "index_settlements_on_player_id"
  end

# Could not dump table "territories" because of following StandardError
#   Unknown type 'territory_terrain_id_type' for column 'terrain_id'

  create_table "turns", force: :cascade do |t|
    t.string "type", null: false
    t.bigint "player_id", null: false
    t.bigint "game_id", null: false
    t.bigint "settlement_id"
    t.bigint "road_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "roll_id"
    t.datetime "ended_at"
    t.datetime "robber_moved_at"
    t.bigint "robber_moved_to_territory_id"
    t.bigint "robbed_player_id"
    t.index ["game_id"], name: "index_turns_on_game_id"
    t.index ["player_id"], name: "index_turns_on_player_id"
    t.index ["road_id"], name: "index_turns_on_road_id"
    t.index ["robbed_player_id"], name: "index_turns_on_robbed_player_id"
    t.index ["robber_moved_to_territory_id"], name: "index_turns_on_robber_moved_to_territory_id"
    t.index ["roll_id"], name: "index_turns_on_roll_id"
    t.index ["settlement_id"], name: "index_turns_on_settlement_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "guest", default: false
    t.text "name"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "adjacencies", "borders"
  add_foreign_key "adjacencies", "corners"
  add_foreign_key "adjacencies", "games"
  add_foreign_key "adjacencies", "territories"
  add_foreign_key "discard_requirements", "players"
  add_foreign_key "discard_requirements", "turns"
  add_foreign_key "games", "territories", column: "robber_territory_id"
  add_foreign_key "games", "turns", column: "current_turn_id"
  add_foreign_key "player_offers", "turns"
  add_foreign_key "players", "games"
  add_foreign_key "players", "rolls", column: "ordering_roll_id"
  add_foreign_key "players", "users"
  add_foreign_key "turns", "games"
  add_foreign_key "turns", "players"
  add_foreign_key "turns", "players", column: "robbed_player_id"
  add_foreign_key "turns", "roads"
  add_foreign_key "turns", "rolls"
  add_foreign_key "turns", "settlements"
  add_foreign_key "turns", "territories", column: "robber_moved_to_territory_id"
end
