class ExaminationResult < ApplicationRecord
  belongs_to :examination, counter_cache: true
  belongs_to :student_profile
  has_one :course, through: :examination

  has_paper_trail
end
