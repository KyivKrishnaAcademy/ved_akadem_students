class Attendance < ApplicationRecord
  belongs_to :class_schedule
  belongs_to :student_profile

  has_paper_trail
end
