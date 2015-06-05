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

ActiveRecord::Schema.define(version: 20150604104338) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "academic_group_schedules", force: :cascade do |t|
    t.integer  "academic_group_id"
    t.integer  "class_schedule_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "academic_groups", force: :cascade do |t|
    t.string   "title",             limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group_description", limit: 255
    t.date     "establ_date"
    t.text     "message_ru"
    t.text     "message_uk"
    t.integer  "praepostor_id"
    t.integer  "curator_id"
    t.integer  "administrator_id"
    t.datetime "graduated_at"
  end

  create_table "answers", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "person_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "class_schedule_id"
    t.integer  "student_profile_id"
    t.boolean  "presence"
  end

  create_table "class_schedules", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.integer  "teacher_profile_id"
    t.integer  "classroom_id"
    t.datetime "start_time"
    t.datetime "finish_time"
  end

  create_table "classrooms", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location",    limit: 255
    t.string   "description", limit: 255
    t.integer  "roominess",               default: 0
    t.string   "title"
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
  end

  create_table "group_participations", force: :cascade do |t|
    t.integer  "student_profile_id"
    t.integer  "academic_group_id"
    t.datetime "join_date"
    t.datetime "leave_date"
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "middle_name",            limit: 255
    t.string   "surname",                limit: 255
    t.string   "spiritual_name",         limit: 255
    t.string   "email",                  limit: 255
    t.boolean  "gender"
    t.date     "birthday"
    t.string   "emergency_contact",      limit: 255
    t.string   "photo",                  limit: 255
    t.boolean  "profile_fullness"
    t.string   "encrypted_password",     limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.boolean  "deleted",                            default: false
    t.string   "passport",               limit: 255
    t.text     "education"
    t.text     "work"
    t.string   "marital_status",         limit: 255
    t.string   "friends_to_be_with",     limit: 255
    t.text     "special_note"
    t.string   "complex_name",           limit: 255
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree

  create_table "people_roles", force: :cascade do |t|
    t.integer "person_id"
    t.integer "role_id"
  end

  create_table "programs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_uk",       limit: 255
    t.string   "title_ru",       limit: 255
    t.text     "description_uk"
    t.text     "description_ru"
    t.text     "courses_uk"
    t.text     "courses_ru"
    t.boolean  "visible",                    default: false
  end

  create_table "programs_questionnaires", id: false, force: :cascade do |t|
    t.integer "questionnaire_id"
    t.integer "program_id"
  end

  create_table "questionnaire_completenesses", force: :cascade do |t|
    t.integer  "questionnaire_id"
    t.integer  "person_id"
    t.boolean  "completed",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "result"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.text     "description_uk"
    t.string   "title_uk",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_ru",       limit: 255
    t.text     "description_ru"
    t.string   "kind",           limit: 255
    t.text     "rule"
  end

  create_table "questions", force: :cascade do |t|
    t.integer  "questionnaire_id"
    t.string   "format",           limit: 255
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "roles", force: :cascade do |t|
    t.string   "activities",            default: [], array: true
    t.string   "name",       limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_profiles", force: :cascade do |t|
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "study_applications", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_profiles", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description", limit: 255
    t.integer  "person_id"
  end

  create_table "teacher_specialities", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_profile_id"
    t.integer  "course_id"
    t.date     "since"
  end

  create_table "telephones", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "phone",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
