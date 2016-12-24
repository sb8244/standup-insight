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

ActiveRecord::Schema.define(version: 20161224162655) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.integer  "stand_up_id",      null: false
    t.integer  "user_id",          null: false
    t.integer  "question_id",      null: false
    t.text     "content",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "question_content", null: false
    t.index ["stand_up_id"], name: "index_answers_on_stand_up_id", using: :btree
    t.index ["user_id"], name: "index_answers_on_user_id", using: :btree
  end

  create_table "groups", force: :cascade do |t|
    t.text     "title",                     null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "groups_users", force: :cascade do |t|
    t.integer "group_id", null: false
    t.integer "user_id",  null: false
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true, using: :btree
    t.index ["group_id"], name: "index_groups_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_groups_users_on_user_id", using: :btree
  end

  create_table "slack_integrations", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "group_id",        null: false
    t.text     "bot_token",       null: false
    t.text     "bot_user_id",     null: false
    t.text     "slack_team_name", null: false
    t.text     "slack_team_id",   null: false
    t.text     "slack_team_url",  null: false
    t.text     "slack_user_id",   null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["group_id"], name: "index_slack_integrations_on_group_id", using: :btree
    t.index ["user_id"], name: "index_slack_integrations_on_user_id", using: :btree
  end

  create_table "slack_user_mappings", force: :cascade do |t|
    t.integer  "user_id",       null: false
    t.integer  "group_id",      null: false
    t.text     "slack_user_id", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["group_id"], name: "index_slack_user_mappings_on_group_id", using: :btree
    t.index ["user_id"], name: "index_slack_user_mappings_on_user_id", using: :btree
  end

  create_table "stand_ups", force: :cascade do |t|
    t.date     "date_of_standup", null: false
    t.integer  "group_id",        null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["group_id"], name: "index_stand_ups_on_group_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",   null: false
    t.string   "encrypted_password",     default: "",   null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,    null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.text     "name"
    t.boolean  "gets_email",             default: true
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  add_foreign_key "answers", "stand_ups"
  add_foreign_key "answers", "users"
  add_foreign_key "groups_users", "groups"
  add_foreign_key "groups_users", "users"
  add_foreign_key "stand_ups", "groups"
end
