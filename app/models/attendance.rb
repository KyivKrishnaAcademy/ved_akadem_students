class Attendance < ApplicationRecord
  belongs_to :class_schedule
  belongs_to :student_profile

  validates :presence, inclusion: { in: [true, false] }
  validates :class_schedule, :student_profile, presence: true

  has_paper_trail
end
