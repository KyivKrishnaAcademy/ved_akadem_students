class Attendance < ApplicationRecord
  belongs_to :class_schedule
  belongs_to :student_profile

  validates :presence, inclusion: { in: [true, false] }

  has_paper_trail
end
