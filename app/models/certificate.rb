class Certificate < ApplicationRecord
  belongs_to :academic_group
  belongs_to :certificate_template, counter_cache: true
  belongs_to :student_profile

  validates :serial_id, :issued_date, :academic_group_id, :certificate_template_id, :student_profile_id, presence: true

  has_paper_trail
end
