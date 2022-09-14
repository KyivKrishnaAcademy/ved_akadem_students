class TeacherProfile < ApplicationRecord
  include Ilikable

  belongs_to :person
  has_many :teacher_specialities, dependent: :destroy
  has_many :class_schedules, dependent: :destroy
  has_many :courses, through: :teacher_specialities

  delegate :complex_name, to: :person

  has_paper_trail
end
