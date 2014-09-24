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

ActiveRecord::Schema.define(version: 20140924202052) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "akadem_groups", force: true do |t|
    t.string   "group_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "group_description"
    t.date     "establ_date"
  end

  create_table "answers", force: true do |t|
    t.integer  "question_id"
    t.integer  "person_id"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "attendances", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "class_schedule_id"
    t.integer  "student_profile_id"
    t.boolean  "presence"
  end

  create_table "class_schedules", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "date"
    t.integer  "course_id"
    t.integer  "teacher_profile_id"
    t.integer  "akadem_group_id"
    t.integer  "classroom_id"
  end

  create_table "classrooms", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "location"
    t.string   "description"
    t.integer  "roominess"
  end

  create_table "courses", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "description"
  end

  create_table "group_participations", force: true do |t|
    t.integer  "student_profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "akadem_group_id"
    t.date     "join_date"
    t.date     "leave_date"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "middle_name"
    t.string   "surname"
    t.string   "spiritual_name"
    t.string   "email"
    t.boolean  "gender"
    t.date     "birthday"
    t.string   "emergency_contact"
    t.string   "photo"
    t.boolean  "profile_fullness"
    t.string   "encrypted_password"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean  "deleted",                default: false
    t.string   "passport"
    t.text     "education"
    t.text     "work"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree

  create_table "people_roles", force: true do |t|
    t.integer "person_id"
    t.integer "role_id"
  end

  create_table "programs", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_uk"
    t.string   "title_ru"
    t.text     "description_uk"
    t.text     "description_ru"
    t.text     "courses_uk"
    t.text     "courses_ru"
  end

  create_table "programs_questionnaires", id: false, force: true do |t|
    t.integer "questionnaire_id"
    t.integer "program_id"
  end

  create_table "questionnaire_completenesses", force: true do |t|
    t.integer  "questionnaire_id"
    t.integer  "person_id"
    t.boolean  "completed",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questionnaires", force: true do |t|
    t.text     "description_uk"
    t.string   "title_uk"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_ru"
    t.text     "description_ru"
  end

  create_table "questions", force: true do |t|
    t.integer  "questionnaire_id"
    t.string   "format"
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "activities",            default: [], array: true
    t.string   "name",       limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_profiles", force: true do |t|
    t.integer  "person_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "questionarie"
    t.boolean  "passport_copy"
    t.boolean  "petition"
    t.boolean  "photos"
    t.string   "folder_in_archive"
    t.boolean  "active_student"
  end

  create_table "study_applications", force: true do |t|
    t.integer  "person_id"
    t.integer  "program_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teacher_profiles", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "description"
    t.integer  "person_id"
  end

  create_table "teacher_specialities", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "teacher_profile_id"
    t.integer  "course_id"
    t.date     "since"
  end

  create_table "telephones", force: true do |t|
    t.integer  "person_id"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
