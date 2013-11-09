class StudentProfile < ActiveRecord::Base
  belongs_to  :person
  has_many    :group_participations, dependent: :destroy
  has_many    :akadem_groups       , through:   :group_participations
  has_many    :attendances         , dependent: :destroy
  has_many    :class_schedules     , through:   :attendances
end
