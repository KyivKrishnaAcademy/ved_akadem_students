class ExaminationResult < ApplicationRecord
  belongs_to :examination
  belongs_to :student_profile
end
