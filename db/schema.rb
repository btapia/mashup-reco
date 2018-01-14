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

ActiveRecord::Schema.define(version: 20170723183937) do

  create_table "api_tags", id: false, force: :cascade do |t|
    t.integer "api_id",     limit: 4, null: false
    t.integer "tag_id",     limit: 4, null: false
    t.boolean "is_primary"
  end

  add_index "api_tags", ["api_id"], name: "fk_apis_tags_apis1_idx", using: :btree
  add_index "api_tags", ["tag_id"], name: "fk_apis_tags_tags1_idx", using: :btree

  create_table "apis", force: :cascade do |t|
    t.string "pw_id",            limit: 255
    t.string "url",              limit: 255
    t.string "name",             limit: 255
    t.string "description",      limit: 10000
    t.string "protocols",        limit: 255
    t.string "provider",         limit: 255
    t.string "wsdl",             limit: 255
    t.string "service_endpoint", limit: 255
    t.string "console_url",      limit: 255
    t.string "api_kits",         limit: 255
    t.string "support",          limit: 255
    t.string "authentication",   limit: 255
    t.string "_ssl",             limit: 255
    t.string "api_hub",          limit: 255
    t.string "twitter",          limit: 255
    t.string "forum",            limit: 255
    t.string "email",            limit: 255
    t.float  "war",              limit: 24
    t.date   "published"
    t.date   "last_collected"
  end

  add_index "apis", ["pw_id"], name: "pw_id_UNIQUE", unique: true, using: :btree

  create_table "cross_validations", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.integer  "k",            limit: 4
    t.integer  "metric",       limit: 4
    t.integer  "dataset_size", limit: 4
    t.integer  "list_size",    limit: 4
    t.float    "score",        limit: 24,  default: 0.0
    t.integer  "status",       limit: 4,   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "folds", force: :cascade do |t|
    t.integer "cross_validation_id", limit: 4
    t.integer "run",                 limit: 4
    t.integer "set_size",            limit: 4
    t.float   "score",               limit: 24, default: 0.0
  end

  create_table "mashup_apis", id: false, force: :cascade do |t|
    t.integer "mashup_id", limit: 4, null: false
    t.integer "api_id",    limit: 4, null: false
  end

  add_index "mashup_apis", ["api_id"], name: "fk_mashups_apis_apis1_idx", using: :btree
  add_index "mashup_apis", ["mashup_id"], name: "fk_mashups_apis_mashups1_idx", using: :btree

  create_table "mashup_tags", id: false, force: :cascade do |t|
    t.integer "mashup_id",  limit: 4, null: false
    t.integer "tag_id",     limit: 4, null: false
    t.boolean "is_primary"
  end

  add_index "mashup_tags", ["mashup_id"], name: "fk_mashups_tags_mashups1_idx", using: :btree
  add_index "mashup_tags", ["tag_id"], name: "fk_mashups_tags_tags1_idx", using: :btree

  create_table "mashups", force: :cascade do |t|
    t.string  "pw_id",          limit: 255
    t.string  "url",            limit: 255
    t.string  "name",           limit: 255
    t.string  "description",    limit: 10000
    t.string  "company",        limit: 255
    t.string  "mashup_type",    limit: 255
    t.date    "published"
    t.date    "last_collected"
    t.string  "author",         limit: 255
    t.string  "comments_url",   limit: 255
    t.date    "date_modified"
    t.string  "icon",           limit: 255
    t.string  "label",          limit: 255
    t.integer "num_comments",   limit: 4
    t.string  "rating",         limit: 255
    t.string  "sample_url",     limit: 255
    t.date    "updated"
    t.string  "use_count",      limit: 255
  end

  add_index "mashups", ["pw_id"], name: "pw_id_UNIQUE", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "TAG",  limit: 255
  end

  add_index "tags", ["name"], name: "tag_UNIQUE", unique: true, using: :btree

  add_foreign_key "api_tags", "apis", name: "FK_apis_tags_api_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "api_tags", "apis", name: "fk_apis_tags_apis1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "api_tags", "tags", name: "FK_apis_tags_tag_id"
  add_foreign_key "api_tags", "tags", name: "fk_apis_tags_tags1"
  add_foreign_key "mashup_apis", "apis", name: "FK_mashups_apis_api_id"
  add_foreign_key "mashup_apis", "apis", name: "fk_mashups_apis_apis1"
  add_foreign_key "mashup_apis", "mashups", name: "FK_mashups_apis_mashup_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mashup_apis", "mashups", name: "fk_mashups_apis_mashups1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mashup_tags", "mashups", name: "FK_mashups_tags_mashup_id", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mashup_tags", "mashups", name: "fk_mashups_tags_mashups1", on_update: :cascade, on_delete: :cascade
  add_foreign_key "mashup_tags", "tags", name: "FK_mashups_tags_tag_id"
  add_foreign_key "mashup_tags", "tags", name: "fk_mashups_tags_tags1"
end
