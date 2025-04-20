class Certificate < ApplicationRecord
  validates :final_score, presence: true, if: -> { certificate_template&.is_final_score_required? }
  belongs_to :academic_group
  belongs_to :certificate_template, counter_cache: true
  belongs_to :student_profile

  validates :serial_id, :issued_date, :certificate_template, :student_profile, presence: true

  has_paper_trail
end
