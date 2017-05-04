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

ActiveRecord::Schema.define(version: 20170504160302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "infected_survivors", id: false, force: :cascade do |t|
    t.integer "infected_id", null: false
    t.integer "survivor_id", null: false
  end

  create_table "inventories", force: :cascade do |t|
    t.integer  "water",       default: 0
    t.integer  "food",        default: 0
    t.integer  "medication",  default: 0
    t.integer  "ammo",        default: 0
    t.integer  "survivor_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["survivor_id"], name: "index_inventories_on_survivor_id", using: :btree
  end

  create_table "survivors", force: :cascade do |t|
    t.string   "name",                            null: false
    t.string   "gender"
    t.integer  "age"
    t.float    "lat"
    t.float    "lng"
    t.boolean  "infected",        default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "infection_count", default: 0
  end

  add_foreign_key "inventories", "survivors"
end
