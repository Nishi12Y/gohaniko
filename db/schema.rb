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

ActiveRecord::Schema[7.2].define(version: 2026_02_11_035243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "user_token", null: false
    t.text "content", null: false
    t.bigint "question_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_answers_on_group_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "group_schedule_dates", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "date"], name: "index_group_schedule_dates_on_group_id_and_date", unique: true
    t.index ["group_id"], name: "index_group_schedule_dates_on_group_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "name", null: false
    t.datetime "outing_schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_groups_on_uuid", unique: true
  end

  create_table "questions", force: :cascade do |t|
    t.string "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "input_type", default: "text", null: false
    t.json "options"
    t.boolean "is_default", default: false, null: false
  end

  create_table "schedule_participants", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name", null: false, comment: "ユーザー名"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "name"], name: "index_schedule_participants_on_group_id_and_name"
    t.index ["group_id"], name: "index_schedule_participants_on_group_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name", null: false, comment: "お店の名前"
    t.string "address", comment: "お店の住所"
    t.string "url", comment: "お店のURL"
    t.integer "status", null: false, comment: "0:候補、1:行き先決定"
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "lat"
    t.float "lng"
    t.index ["group_id", "url"], name: "index_shops_on_group_id_and_url", unique: true
    t.index ["group_id"], name: "index_shops_on_group_id"
  end

  create_table "user_schedules", force: :cascade do |t|
    t.bigint "group_schedule_date_id", null: false
    t.bigint "schedule_participant_id", null: false
    t.integer "choice", null: false, comment: "0:×、1:△、2:○"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_schedule_date_id", "schedule_participant_id"], name: "index_user_schedules_on_date_and_participant", unique: true
    t.index ["group_schedule_date_id"], name: "index_user_schedules_on_group_schedule_date_id"
    t.index ["schedule_participant_id"], name: "index_user_schedules_on_schedule_participant_id"
  end

  create_table "votes", force: :cascade do |t|
    t.string "user_token", null: false, comment: "ユーザー識別用トークン"
    t.integer "score", null: false, comment: "投票スコア"
    t.bigint "shop_id", null: false
    t.bigint "group_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "shop_id"], name: "index_votes_on_group_id_and_shop_id"
    t.index ["group_id", "user_token", "shop_id"], name: "index_votes_on_group_id_and_user_token_and_shop_id", unique: true
    t.index ["group_id"], name: "index_votes_on_group_id"
    t.index ["shop_id"], name: "index_votes_on_shop_id"
  end

  add_foreign_key "answers", "groups"
  add_foreign_key "answers", "questions"
  add_foreign_key "group_schedule_dates", "groups"
  add_foreign_key "schedule_participants", "groups"
  add_foreign_key "shops", "groups"
  add_foreign_key "user_schedules", "group_schedule_dates"
  add_foreign_key "user_schedules", "schedule_participants"
  add_foreign_key "votes", "groups"
  add_foreign_key "votes", "shops"
end
