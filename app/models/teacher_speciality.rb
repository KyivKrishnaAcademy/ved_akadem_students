class TeacherSpeciality < ApplicationRecord
  belongs_to :course
  belongs_to :teacher_profile

  validates :teacher_profile_id, uniqueness: { scope: :course_id }
  validates :course_id, uniqueness: { scope: :teacher_profile_id }

  has_paper_trail
end
