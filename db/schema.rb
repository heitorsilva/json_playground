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

ActiveRecord::Schema.define(version: 2019_01_07_230035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "vehicles", force: :cascade do |t|
    t.string "name"
    t.string "brand"
    t.jsonb "description"
    t.jsonb "schema", default: {"required"=>["color"], "attributes"=>{"alarm"=>{"type"=>"boolean", "default"=>false}, "color"=>{"type"=>"string", "default"=>""}, "wheels"=>{"type"=>"integer", "default"=>2}}}, null: false
    t.index ["description"], name: "index_vehicles_on_description", using: :gin
    t.index ["schema"], name: "index_vehicles_on_schema", using: :gin
  end

end
