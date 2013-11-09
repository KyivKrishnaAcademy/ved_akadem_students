class TeacherProfile < ActiveRecord::Base
  has_many    :teacher_specialities, dependent: :destroy
  has_many    :class_schedules     , dependent: :destroy
  has_many    :courses             , through:   :teacher_specialities
end
