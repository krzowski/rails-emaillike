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

ActiveRecord::Schema.define(version: 20171214092335) do

  create_table "contacts", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "name"
  end

  add_index "contacts", ["user_id"], name: "index_contacts_on_user_id"

  create_table "drafts", force: :cascade do |t|
    t.string   "username"
    t.string   "title"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "drafts", ["user_id"], name: "index_drafts_on_user_id"

  create_table "emails", force: :cascade do |t|
    t.text     "title"
    t.text     "message"
    t.integer  "user_id"
    t.integer  "interlocutor_id"
    t.string   "message_type"
    t.integer  "label_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "username"
    t.boolean  "trash",           default: false
  end

  add_index "emails", ["interlocutor_id"], name: "index_emails_on_interlocutor_id"
  add_index "emails", ["label_id"], name: "index_emails_on_label_id"
  add_index "emails", ["message_type"], name: "index_emails_on_message_type"
  add_index "emails", ["user_id"], name: "index_emails_on_user_id"

  create_table "labels", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "labels", ["user_id"], name: "index_labels_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["username"], name: "index_users_on_username"

end
