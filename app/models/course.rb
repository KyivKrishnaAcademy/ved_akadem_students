class Course < ActiveRecord::Base
  has_many :class_schedules, dependent: :destroy
  has_many :teacher_specialities, dependent: :destroy
  has_many :teacher_profiles, through: :teacher_specialities
end
