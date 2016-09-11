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

ActiveRecord::Schema.define(version: 20160910132717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "properties", force: :cascade do |t|
    t.string   "address"
    t.string   "amenities"
    t.string   "community"
    t.text     "description"
    t.string   "floorplans"
    t.string   "emails",                    array: true
    t.string   "latitude"
    t.string   "longitude"
    t.string   "parking"
    t.string   "pet_policy"
    t.string   "phones"
    t.string   "photos"
    t.string   "primary_name"
    t.string   "uid"
    t.string   "urls"
    t.string   "utility"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
