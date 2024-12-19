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

ActiveRecord::Schema.define(version: 20241219135735) do

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

  create_table "academic_groups_courses", id: false, force: :cascade do |t|
    t.integer "academic_group_id", null: false
    t.integer "course_id",         null: false
    t.index ["academic_group_id", "course_id"], name: "index_academic_groups_courses_on_group_id_and_course_id", using: :btree
    t.index ["course_id", "academic_group_id"], name: "index_academic_groups_courses_on_course_id_and_group_id", using: :btree
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
    t.integer  "revision",           default: 1
    t.index ["class_schedule_id", "student_profile_id"], name: "index_attendances_on_class_schedule_id_and_student_profile_id", unique: true, using: :btree
  end

  create_table "certificate_template_entries", force: :cascade do |t|
    t.string   "template"
    t.integer  "certificate_template_id"
    t.integer  "certificate_template_font_id"
    t.float    "character_spacing",            default: 0.5
    t.integer  "x",                            default: 0
    t.integer  "y",                            default: 0
    t.integer  "font_size",                    default: 16
    t.integer  "align",                        default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "color",                        default: "#000000", null: false
    t.index ["certificate_template_font_id"], name: "index_certificate_template_entries_on_font_id", using: :btree
    t.index ["certificate_template_id"], name: "index_certificate_template_entries_on_template_id", using: :btree
  end

  create_table "certificate_template_fonts", force: :cascade do |t|
    t.string   "name"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_certificate_template_fonts_on_name", unique: true, using: :btree
  end

  create_table "certificate_template_images", force: :cascade do |t|
    t.integer  "certificate_template_id"
    t.integer  "signature_id"
    t.float    "scale",                   default: 1.0
    t.integer  "x",                       default: 0
    t.integer  "y",                       default: 0
    t.float    "angle",                   default: 0.0
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.index ["certificate_template_id"], name: "index_certificate_template_images_on_certificate_template_id", using: :btree
    t.index ["signature_id"], name: "index_certificate_template_images_on_signature_id", using: :btree
  end

  create_table "certificate_templates", force: :cascade do |t|
    t.string   "title"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "file"
    t.integer  "institution_id"
    t.integer  "program_type",       default: 0
    t.integer  "certificates_count", default: 0
    t.index ["institution_id"], name: "index_certificate_templates_on_institution_id", using: :btree
  end

  create_table "certificates", force: :cascade do |t|
    t.integer  "academic_group_id"
    t.integer  "certificate_template_id"
    t.integer  "student_profile_id"
    t.datetime "issued_date"
    t.string   "serial_id"
    t.integer  "final_score"
    t.index ["academic_group_id"], name: "index_certificates_on_academic_group_id", using: :btree
    t.index ["certificate_template_id"], name: "index_certificates_on_certificate_template_id", using: :btree
    t.index ["serial_id"], name: "index_certificates_on_serial_id", unique: true, using: :btree
    t.index ["student_profile_id"], name: "index_certificates_on_student_profile_id", using: :btree
  end

  create_table "class_schedules", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "course_id"
    t.integer  "teacher_profile_id"
    t.integer  "classroom_id"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string   "subject"
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
    t.string   "title",                     limit: 255
    t.string   "description",               limit: 255
    t.string   "variant"
    t.integer  "examination_results_count",             default: 0
    t.integer  "class_schedules_count",                 default: 0
  end

  create_table "examination_results", force: :cascade do |t|
    t.integer  "examination_id"
    t.integer  "student_profile_id"
    t.integer  "score"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["examination_id"], name: "index_examination_results_on_examination_id", using: :btree
    t.index ["student_profile_id"], name: "index_examination_results_on_student_profile_id", using: :btree
  end

  create_table "examinations", force: :cascade do |t|
    t.string   "title",                     default: ""
    t.text     "description",               default: ""
    t.integer  "passing_score",             default: 1
    t.integer  "min_result",                default: 0
    t.integer  "max_result",                default: 1
    t.integer  "course_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "examination_results_count", default: 0
    t.index ["course_id"], name: "index_examinations_on_course_id", using: :btree
  end

  create_table "group_participations", force: :cascade do |t|
    t.integer  "student_profile_id"
    t.integer  "academic_group_id"
    t.datetime "join_date"
    t.datetime "leave_date"
  end

  create_table "institutions", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "person_id"
    t.date     "date"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_notes_on_person_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "middle_name",            limit: 255
    t.string   "surname",                limit: 255
    t.string   "email",                  limit: 255
    t.boolean  "gender"
    t.date     "birthday"
    t.string   "photo",                  limit: 255
    t.string   "encrypted_password",     limit: 255
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.string   "complex_name",           limit: 255
    t.string   "provider",                           default: "email", null: false
    t.string   "uid",                                default: "",      null: false
    t.jsonb    "tokens",                             default: {},      null: false
    t.string   "locale",                 limit: 2,   default: "uk"
    t.boolean  "fake_email",                         default: false
    t.string   "diploma_name"
    t.boolean  "notify_schedules",                   default: true
    t.boolean  "spam_complain",                      default: false
    t.index ["email"], name: "index_people_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
    t.index ["uid", "provider"], name: "index_people_on_uid_and_provider", unique: true, using: :btree
  end

  create_table "people_roles", force: :cascade do |t|
    t.integer "person_id"
    t.integer "role_id"
  end

  create_table "programs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title_uk",                 limit: 255
    t.string   "title_ru",                 limit: 255
    t.text     "description_uk"
    t.text     "description_ru"
    t.boolean  "visible",                              default: false
    t.integer  "manager_id"
    t.integer  "position"
    t.integer  "study_applications_count",             default: 0
    t.integer  "questionnaires_count",                 default: 0
  end

  create_table "programs_questionnaires", force: :cascade do |t|
    t.integer "questionnaire_id"
    t.integer "program_id"
    t.index ["program_id", "questionnaire_id"], name: "index_programs_questionnaires_on_p_and_q", unique: true, using: :btree
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
    t.string   "activities", limit: 255, default: [], array: true
    t.string   "name",       limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "signatures", force: :cascade do |t|
    t.string   "name"
    t.string   "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_signatures_on_name", unique: true, using: :btree
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
    t.index ["person_id"], name: "index_study_applications_on_person_id", unique: true, using: :btree
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
  end

  create_table "telephones", force: :cascade do |t|
    t.integer  "person_id"
    t.string   "phone",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unsubscribes", force: :cascade do |t|
    t.string   "email"
    t.string   "code"
    t.string   "kind"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "code"], name: "index_unsubscribes_on_email_and_code", unique: true, using: :btree
    t.index ["person_id"], name: "index_unsubscribes_on_person_id", using: :btree
  end

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "certificate_template_entries", "certificate_template_fonts"
  add_foreign_key "certificate_template_entries", "certificate_templates"
  add_foreign_key "certificate_template_images", "certificate_templates"
  add_foreign_key "certificate_template_images", "signatures"
  add_foreign_key "certificates", "academic_groups"
  add_foreign_key "certificates", "certificate_templates"
  add_foreign_key "certificates", "student_profiles"
  add_foreign_key "examination_results", "examinations"
  add_foreign_key "examination_results", "student_profiles"
  add_foreign_key "examinations", "courses"
  add_foreign_key "unsubscribes", "people"
end
