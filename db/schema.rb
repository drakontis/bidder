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

ActiveRecord::Schema.define(version: 20171008124901) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bid_submissions", force: true do |t|
    t.string  "bid_request_id", null: false
    t.string  "campaign_id",    null: false
    t.decimal "price",          null: false
    t.text    "adm",            null: false
  end

  add_index "bid_submissions", ["bid_request_id"], name: "bid_submissions_bid_request_id_idx", using: :btree
  add_index "bid_submissions", ["campaign_id"], name: "bid_submissions_campaign_id_idx", using: :btree

end
