class Certificate < ApplicationRecord
  belongs_to :academic_group
  belongs_to :certificate_template, counter_cache: true
  belongs_to :student_profile

  validates :serial_id, :issued_date, :certificate_template, :student_profile, presence: true

  has_paper_trail
end
